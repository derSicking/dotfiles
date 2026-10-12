import { existsSync } from "node:fs";
import { join } from "node:path";
import { Plugin } from "@opencode/plugin";

/**
 * ytmcp-enroll: enables the globally-defined `ytmcp` MCP server for repos that
 * opt in.
 *
 * V2 replaces a same-name MCP server object rather than merging it, so a repo
 * cannot flip `disabled` in its own config. The server stays defined once
 * (disabled) in the global config; a repo opts in by adding the marker
 * `.opencode/ytmcp.json`, and this plugin enables the shared definition for
 * that location.
 */

const SERVER_NAME = "ytmcp";
const MARKER = join(".opencode", "ytmcp.json");

export default Plugin.define({
  id: "ytmcp-enroll",
  async setup(ctx) {
    if (!existsSync(join(ctx.location.directory, MARKER))) return;

    await ctx.mcp.transform((editor) => {
      editor.update(SERVER_NAME, (server) => {
        server.disabled = false;
      });
    });
  },
});
