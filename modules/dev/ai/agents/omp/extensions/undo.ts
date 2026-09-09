/**
 * /undo command for omp.
 *
 * Walks back through the session tree to the previous user message and
 * navigates there, effectively undoing the last exchange. The undone
 * message text is restored to the input buffer for re-editing.
 * The abandoned branch remains accessible via /tree.
 *
 * Usage: /undo [n]   (default n=1, undoes n exchanges back)
 */

// Inline types — @oh-my-pi/pi-coding-agent is bundled inside omp and not
 // resolvable as an external module at extension load time.
interface SessionEntry {
  type: string;
  id: string;
  parentId: string | null;
  timestamp?: string;
  message?: {
    role: string;
    content: unknown;
  };
}

interface NavigateTreeResult {
  cancelled: boolean;
}

interface ExtensionCommandContext {
  sessionManager: {
    getBranch: () => SessionEntry[];
  };
  navigateTree: (entryId: string, opts?: { summarize?: boolean; label?: string }) => Promise<NavigateTreeResult>;
  waitForIdle: () => Promise<void>;
  ui: {
    setEditorText: (text: string) => void;
    notify: (message: string, level?: string) => void;
  };
}

interface ExtensionAPI {
  registerCommand: (name: string, opts: {
    description: string;
    handler: (args: string, ctx: ExtensionCommandContext) => Promise<void>;
  }) => void;
}

export default function (pi: ExtensionAPI) {
  pi.registerCommand("undo", {
    description: "Undo the last n exchanges (default 1)",
    handler: async (args, ctx) => {
      await ctx.waitForIdle();

      const n = Math.max(1, parseInt(args, 10) || 1);
      const entries = ctx.sessionManager.getBranch();

      if (!entries || entries.length === 0) {
        ctx.ui.notify("No session entries to undo.");
        return;
      }

      // Walk entries in reverse to find the nth user message from the end.
      // Each "exchange" = one user message + its response chain.
      // To undo n exchanges, we navigate to the nth user message's parentId
      // (the point before that message was sent).
      let userCount = 0;
      let targetEntry: SessionEntry | null = null;

      for (let i = entries.length - 1; i >= 0; i--) {
        const entry = entries[i];
        if (
          entry.type === "message" &&
          entry.message?.role === "user"
        ) {
          userCount++;
          if (userCount === n) {
            targetEntry = entry;
            break;
          }
        }
      }

      if (!targetEntry) {
        ctx.ui.notify(
          `Only ${userCount} user message(s) in this branch; cannot undo ${n}.`,
        );
        return;
      }

      // Extract text from the user message content blocks.
      const textParts: string[] = [];
      const content = targetEntry.message!.content;
      if (Array.isArray(content)) {
        for (const block of content) {
          if (
            block &&
            typeof block === "object" &&
            (block as { type?: string }).type === "text" &&
            typeof (block as { text?: string }).text === "string"
          ) {
            textParts.push((block as { text: string }).text);
          }
        }
      }
      const messageText = textParts.join("\n");

      // Navigate to the point before the user message was sent.
      // navigateTree moves the leaf pointer back — the abandoned branch
      // stays reachable via /tree.
      const targetId = targetEntry.parentId;
      if (!targetId) {
        // First message in the branch — can't navigate further back.
        ctx.ui.setEditorText(messageText);
        ctx.ui.notify("Undid to the start of the branch. Message restored to input.");
        return;
      }

      const result = await ctx.navigateTree(targetId, {
        summarize: false,
        label: `undo (${n})`,
      });

      if (result.cancelled) {
        ctx.ui.notify("Undo cancelled.");
        return;
      }

      // Restore the undone message text to the input buffer.
      ctx.ui.setEditorText(messageText);
      ctx.ui.notify("Undone message loaded. Press Enter to resend, or edit first.", "info");
    },
  });
}
