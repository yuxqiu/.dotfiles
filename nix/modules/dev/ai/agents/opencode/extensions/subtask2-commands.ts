/**
 * /s2 command plugin for opencode
 *
 * Provides a YAML-block DSL for subtask2 features, translating them
 * to /subtask inline syntax which subtask2 processes natively.
 *
 * Supports nested /s2 blocks inside return and parallel sections.
 *
 * Strict mode: in multi-line (block) format, free-form text outside
 * sections is forbidden. Only `model:`, `agent:`, and section headers
 * (`loop`, `return`, `parallel`) are valid at the top level.
 * Simple one-liners (`/s2 Fix this bug`) are still allowed.
 *
 * When no prompt is provided (only sections), "Execute" is used as
 * a placeholder because subtask2 requires non-empty text after `}`.
 *
 * Usage:
 *   /s2 Fix this bug
 *
 *   /s2
 *   loop
 *   - max: 10
 *   - until: tests pass
 *   - Fix the failing tests
 *   return
 *   - Review the result
 *
 *   /s2
 *   parallel
 *   - /plan arg
 *   - /plan arg
 *
 *   /s2
 *   return
 *   - /s2
 *     loop
 *     - max: 10
 *     - until: tests pass
 *     - Fix failing tests
 *   - /s2
 *     parallel
 *     - /A arg
 *     - /B arg
 *   - Check the result
 */

import type { Plugin } from "@opencode-ai/plugin"

interface LoopConfig {
  max: number
  until: string
}

interface S2Config {
  prompt: string
  loop?: LoopConfig
  return?: string[]
  parallel?: string[]
  model?: string
  agent?: string
}

interface ParseResult {
  sections: Record<string, BlockNode[]>
  topLines: string[]
  errors: string[]
}

type BlockNode =
  | { type: "text"; content: string }
  | { type: "s2"; content: string }

function getIndent(line: string): number {
  let i = 0
  while (i < line.length && line[i] === " ") i++
  return i
}

function parseInput(input: string): ParseResult {
  const lines = input.split("\n")
  const sections: Record<string, BlockNode[]> = {}
  let currentSection: string | null = null
  const topLines: string[] = []
  const errors: string[] = []
  const sectionKeywords = ["loop", "return", "parallel"]

  let i = 0
  while (i < lines.length) {
    const line = lines[i]!
    const trimmed = line.trim()
    if (trimmed === "") { i++; continue }

    if (currentSection === null) {
      if (sectionKeywords.includes(trimmed.toLowerCase())) {
        currentSection = trimmed.toLowerCase()
        if (!sections[currentSection]) sections[currentSection] = []
        i++
        continue
      }
      topLines.push(line)
      i++
      continue
    }

    // Check for section switch while inside a section
    if (sectionKeywords.includes(trimmed.toLowerCase())) {
      currentSection = trimmed.toLowerCase()
      if (!sections[currentSection]) sections[currentSection] = []
      i++
      continue
    }

    const baseIndent = getIndent(line)
    const isBullet = trimmed.startsWith("- ")

    if (isBullet) {
      const itemContent = trimmed.slice(2).trim()
      if (itemContent.toLowerCase() === "/s2") {
        // Nested /s2 block: collect indented lines until dedent
        const blockLines: string[] = []
        let j = i + 1
        while (j < lines.length) {
          const nextLine = lines[j]!
          if (nextLine.trim() === "") { j++; continue }
          const nextIndent = getIndent(nextLine)
          if (nextIndent <= baseIndent) break
          blockLines.push(nextLine.trim())
          j++
        }
        sections[currentSection]!.push({ type: "s2", content: blockLines.join("\n") })
        i = j
      } else {
        sections[currentSection]!.push({ type: "text", content: itemContent })
        i++
      }
    } else {
      // Non-bullet line inside section — property or continuation
      sections[currentSection]!.push({ type: "text", content: trimmed })
      i++
    }
  }

  return { sections, topLines, errors }
}

function resolveBlock(node: BlockNode): string {
  if (node.type === "text") return node.content
  // Nested /s2: parse and translate to /subtask inline syntax
  const config = parseS2(node.content)
  if ("error" in config) return node.content
  return buildInlineSyntax(config)
}

function isOneLiner(input: string): boolean {
  const lines = input.split("\n").map(l => l.trim()).filter(l => l !== "")
  if (lines.length === 0) return false
  if (lines.length === 1) {
    // Structured keywords are never one-liners
    const line = lines[0]!
    if (/^(model|agent|loop|return|parallel):?/i.test(line)) return false
    return true
  }
  return false
}

function parseS2(input: string): S2Config | { error: string } {
  // Simple one-liner: pass through as-is
  if (isOneLiner(input)) {
    return { prompt: input.trim() }
  }

  const { sections, topLines } = parseInput(input)

  let prompt = ""
  let model: string | undefined
  let agent: string | undefined
  const errors: string[] = []

  for (const line of topLines) {
    const trimmed = line.trim()
    const modelMatch = trimmed.match(/^model:\s*(.+)$/i)
    const agentMatch = trimmed.match(/^agent:\s*(.+)$/i)
    if (modelMatch) {
      model = modelMatch[1]!.trim()
    } else if (agentMatch) {
      agent = agentMatch[1]!.trim()
    } else {
      errors.push(`unexpected top-level text: "${trimmed}" — only model:/agent: and section headers (loop, return, parallel) are allowed in block format`)
    }
  }

  if (errors.length > 0) {
    return { error: errors.join("; ") }
  }

  const loop = parseLoopSection(sections["loop"] || [])
  if (loop) {
    prompt = loop.prompt
  }

  const returnItems = (sections["return"] || []).map(resolveBlock)
  const parallelItems = (sections["parallel"] || []).map(resolveBlock)

  const result: S2Config = { prompt: prompt.trim() }
  if (loop) result.loop = { max: loop.max, until: loop.until }
  if (returnItems.length > 0) result.return = returnItems
  if (parallelItems.length > 0) result.parallel = parallelItems
  if (model) result.model = model
  if (agent) result.agent = agent

  return result
}

interface ParsedLoop extends LoopConfig {
  prompt: string
}

function parseLoopSection(nodes: BlockNode[]): ParsedLoop | null {
  if (nodes.length === 0) return null

  let max = 5
  let until = ""
  const promptParts: string[] = []

  for (const node of nodes) {
    const text = node.type === "text" ? node.content : resolveBlock(node)
    const maxMatch = text.match(/^max:\s*(\d+)$/i)
    const untilMatch = text.match(/^until:\s*(.+)$/i)
    if (maxMatch) {
      max = parseInt(maxMatch[1]!, 10)
    } else if (untilMatch) {
      until = untilMatch[1]!.trim()
    } else {
      promptParts.push(text)
    }
  }

  return { max, until, prompt: promptParts.join(" ") }
}

function buildInlineSyntax(config: S2Config): string {
  const overrides: string[] = []

  if (config.model) overrides.push(`model:${config.model}`)
  if (config.agent) overrides.push(`agent:${config.agent}`)
  if (config.loop) {
    overrides.push(`loop:${config.loop.max}`)
    if (config.loop.until) overrides.push(`until:${config.loop.until}`)
  }
  if (config.return && config.return.length > 0) {
    overrides.push(`return:${config.return.join("||")}`)
  }
  if (config.parallel && config.parallel.length > 0) {
    overrides.push(`parallel:${config.parallel.join("||")}`)
  }

  const overrideStr = overrides.length > 0 ? `{${overrides.join(" && ")}}` : ""
  // subtask2 requires non-empty text after the } block; use "Execute" as placeholder
  const prompt = config.prompt || (overrides.length > 0 ? "Execute" : "")

  if (overrideStr && prompt) return `/subtask ${overrideStr} ${prompt}`
  if (prompt) return `/subtask ${prompt}`
  return ""
}

export const Subtask2CommandsPlugin: Plugin = async (ctx) => {
  return {
    config: async (input: any) => {
      input.command ??= {}
      input.command["s2"] = {
        description:
          "Structured subtask2 command (loop, return, parallel, model, agent)",
        template: "$ARGUMENTS",
      }
    },

    "command.execute.before": async (input, output) => {
      if (input.command !== "s2") return

      const args = input.arguments?.trim() ?? ""
      if (!args) return

      const config = parseS2(args)

      if ("error" in config) {
        throw new Error(`/s2 error: ${config.error}`)
      }

      const command = buildInlineSyntax(config as S2Config)
      if (!command) return

      try {
        await ctx.client.session.command({
          path: { id: input.sessionID },
          body: { command: "subtask", arguments: command.replace(/^\/subtask\s*/, "") },
        })
      } catch {}

      throw new Error(`/s2 → ${command}`)
    },
  }
}

export default Subtask2CommandsPlugin