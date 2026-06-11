/**
 * Standalone test harness for /s2 plugin logic.
 * Strips the Plugin export and runs parseS2 + buildInlineSyntax directly.
 *
 * Run: nix-shell -p bun --run "bun test-s2.ts"
 */

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
      sections[currentSection]!.push({ type: "text", content: trimmed })
      i++
    }
  }

  return { sections, topLines, errors }
}

function resolveBlock(node: BlockNode): string {
  if (node.type === "text") return node.content
  const config = parseS2(node.content)
  if ("error" in config) return node.content
  return buildInlineSyntax(config as S2Config)
}

function isOneLiner(input: string): boolean {
  const lines = input.split("\n").map(l => l.trim()).filter(l => l !== "")
  if (lines.length === 0) return false
  if (lines.length === 1) {
    const line = lines[0]!
    if (/^(model|agent|loop|return|parallel):?/i.test(line)) return false
    return true
  }
  return false
}

function parseS2(input: string): S2Config | { error: string } {
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

function parseLoopSection(nodes: BlockNode[]): { max: number; until: string; prompt: string } | null {
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

// --- Test harness ---

function translate(input: string): string {
  const config = parseS2(input)
  if ("error" in config) {
    return `ERROR: ${config.error}`
  }
  return buildInlineSyntax(config)
}

let pass = 0
let fail = 0

function test(name: string, input: string, expected: string) {
  const result = translate(input)
  if (result === expected) {
    pass++
    console.log(`  PASS: ${name}`)
  } else {
    fail++
    console.log(`  FAIL: ${name}`)
    console.log(`    Input:    ${JSON.stringify(input)}`)
    console.log(`    Expected: ${expected}`)
    console.log(`    Got:      ${result}`)
  }
}

// --- Tests ---
// Note: subtask2 requires a prompt after the {overrides} block.
// When the user provides no prompt (only sections), we use "Execute" as placeholder.

console.log("\n=== Simple one-liner ===")
test("simple prompt",
  "Fix this bug",
  "/subtask Fix this bug")

console.log("\n=== Loop only ===")
test("loop with prompt",
  "loop\n- max: 10\n- until: tests pass\n- Fix the failing tests",
  "/subtask {loop:10 && until:tests pass} Fix the failing tests")

test("loop default max",
  "loop\n- until: done\n- Do the thing",
  "/subtask {loop:5 && until:done} Do the thing")

console.log("\n=== Loop + Return ===")
test("loop with return",
  "loop\n- max: 5\n- until: all features implemented\n- Implement the feature\n\nreturn\n- Review the result\n- Run the tests",
  "/subtask {loop:5 && until:all features implemented && return:Review the result||Run the tests} Implement the feature")

console.log("\n=== Parallel (no prompt — uses Execute placeholder) ===")
test("parallel with args",
  "parallel\n- /plan arg1\n- /plan arg2",
  "/subtask {parallel:/plan arg1||/plan arg2} Execute")

test("parallel bare commands",
  "parallel\n- /research\n- /analyze",
  "/subtask {parallel:/research||/analyze} Execute")

console.log("\n=== Model and Agent ===")
test("model override",
  "model: anthropic/claude-sonnet-4.5\n\nloop\n- Fix this",
  "/subtask {model:anthropic/claude-sonnet-4.5 && loop:5} Fix this")

test("agent override",
  "agent: coder\n\nloop\n- Write the code",
  "/subtask {agent:coder && loop:5} Write the code")

test("model only (no prompt, no sections)",
  "model: gpt-4",
  "/subtask {model:gpt-4} Execute")

console.log("\n=== Nested /s2 in return ===")
test("nested /s2 in return",
  "return\n- /s2\n  loop\n  - max: 10\n  - until: tests pass\n  - Fix failing tests\n- Check the result",
  "/subtask {return:/subtask {loop:10 && until:tests pass} Fix failing tests||Check the result} Execute")

console.log("\n=== Nested /s2 in parallel ===")
test("nested /s2 in parallel",
  "parallel\n- /s2\n  loop\n  - max: 3\n  - Do task A\n- /s2\n  loop\n  - max: 5\n  - Do task B",
  "/subtask {parallel:/subtask {loop:3} Do task A||/subtask {loop:5} Do task B} Execute")

console.log("\n=== Strict validation: reject free-form text in block format ===")
test("reject free-form text at top level in block format",
  "Fix this bug\n\nloop\n- max: 10\n- Do the thing",
  "ERROR: unexpected top-level text: \"Fix this bug\" — only model:/agent: and section headers (loop, return, parallel) are allowed in block format")

test("reject multiple free-form lines in block format",
  "Some random text\nMore text\n\nloop\n- Do the thing",
  "ERROR: unexpected top-level text: \"Some random text\" — only model:/agent: and section headers (loop, return, parallel) are allowed in block format; unexpected top-level text: \"More text\" — only model:/agent: and section headers (loop, return, parallel) are allowed in block format")

console.log("\n=== Empty lines are allowed ===")
test("empty lines between sections",
  "loop\n- max: 10\n- until: done\n- Do it\n\nreturn\n- Check result",
  "/subtask {loop:10 && until:done && return:Check result} Do it")

console.log("\n=== Full composition ===")
test("model + loop + parallel + return",
  "model: anthropic/claude-sonnet-4.5\n\nloop\n- max: 5\n- until: all features implemented\n- Implement the feature\n\nparallel\n- /research-docs auth flow\n- /research-codebase auth middleware\n\nreturn\n- Synthesize findings\n- /review-plan",
  "/subtask {model:anthropic/claude-sonnet-4.5 && loop:5 && until:all features implemented && return:Synthesize findings||/review-plan && parallel:/research-docs auth flow||/research-codebase auth middleware} Implement the feature")

console.log("\n=== Edge cases ===")
test("empty input",
  "",
  "")

test("return only, no loop (uses Execute placeholder)",
  "return\n- Do the thing",
  "/subtask {return:Do the thing} Execute")

test("parallel only, no loop (uses Execute placeholder)",
  "parallel\n- /cmd1\n- /cmd2",
  "/subtask {parallel:/cmd1||/cmd2} Execute")

test("loop without until",
  "loop\n- max: 3\n- Do the thing",
  "/subtask {loop:3} Do the thing")

test("parallel with /command and args (spaces in args, uses Execute placeholder)",
  "parallel\n- /plan implement auth\n- /research codebase patterns",
  "/subtask {parallel:/plan implement auth||/research codebase patterns} Execute")

test("agent + return only (uses Execute placeholder)",
  "agent: coder\n\nreturn\n- Write the code\n- Test it",
  "/subtask {agent:coder && return:Write the code||Test it} Execute")

// Note: nested /s2 with parallel inside return has a known limitation:
// the || inside the nested {parallel:...} will be split at the parent level
// because subtask2's parseOverridesString splits on || naively.
// This is a subtask2 limitation, not a /s2 plugin bug.

console.log(`\n${pass} passed, ${fail} failed`)
if (fail > 0) process.exit(1)