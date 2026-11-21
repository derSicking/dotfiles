---
name: youtrack-init
description:
  Use when the user asks to connect this repo to the YouTrack MCP — "set up
  youtrack", "connect this repo to youtrack", "init the board", or when the
  ytmcp tools are missing and a repo needs the opt-in. Opts the repo in to the
  ytmcp server for the harness running the skill (and, on request, for the other
  harnesses), then connects the repo to its project via list_projects and
  records it. Idempotent, so rerunning reconciles rather than duplicating.
---

# Skill: youtrack-init

Connect a repo to the hosted ytmcp MCP and to the right YouTrack project, so the
`youtrack-*` skills can operate on it. This is the bootstrap that pick, refine,
capture, work, and verify all reference in their Preconditions ("run
`youtrack-init` to opt the repo in"). Always idempotent: running it again
reconciles rather than duplicating.

**First, read the shared conventions:** `../_shared/youtrack-conventions.md`,
relative to this skill's directory (e.g. `~/.claude/skills/_shared/…` or
`~/.config/opencode/skills/_shared/…`)

## Harnesses

The opt-in is per harness. Supported harnesses, each with its own opt-in section
below:

- **Claude Code** — you are running in it if you are Claude Code (its shell sets
  `CLAUDECODE=1`).
- **OpenCode** — you are running in it if you are OpenCode.

The **running harness** is the one executing this skill; every other supported
harness is an **other harness**.

## Step 0 — Detect the phase

1. Determine the running harness.
2. Note whether the `ytmcp` server's tools are available in this session.
3. Read `.ytmcp.json` at the repo root, if present.
4. **Legacy migration:** if the legacy marker `.opencode/ytmcp.json` exists:
   when `.ytmcp.json` is absent, create it, carrying over the marker's `project`
   if non-empty (else `""`); then delete the legacy marker — `.ytmcp.json` is
   now the OpenCode opt-in. Leave the `.opencode/` directory and its other
   files alone. Tell the user.

- **MCP tools absent → Phase 1 (bootstrap).**
- **MCP tools present → Phase 2 (connect).**

## Phase 1 — Bootstrap the opt-in

1. **Create the project record** if missing: `.ytmcp.json` at the repo root,
   starting with an empty project — Phase 2 fills it in:

   ```json
   { "project": "" }
   ```

   This file is also what enables the `ytmcp` server in OpenCode (see Opt-in:
   OpenCode), whichever harness creates it.

2. **Apply the opt-in for the running harness** (its section below).
3. **Ask about the other harnesses.** For each other harness whose opt-in is not
   already in place, ask (question tool) whether to also add its opt-in. Apply
   only the ones the user chooses.
4. Show the user the exact files and config entries written.
5. **Stop** and tell the user how to reload the running harness (its section),
   then say `continue` to resume this skill.

If the MCP is still unavailable after the reload, the global YouTrack setup or
the token is wrong — point at the token secret
(`~/.dotfiles/secrets/youtrack-token`) and the harness's server definition, and
stop. Do not try to fix credentials yourself.

### Opt-in: Claude Code

1. **Register the server for this repo at local scope.** Check first with
   `claude mcp get ytmcp` (run from the repo root); skip if a local-scope
   `ytmcp` entry already exists. Otherwise run, from the repo root, exactly:

   ```sh
   claude mcp add-json --scope local ytmcp "$(cat <<'EOF'
   {"type":"http","url":"https://ytmcp.dersicking.de","headersHelper":"printf '{\"Authorization\":\"Bearer %s\"}' \"$(cat ~/.dotfiles/secrets/youtrack-token)\""}
   EOF
   )"
   ```

   The entry is stored in the repo's project entry in `~/.claude.json`, private
   to the user and never in the repo. The token stays only in the secrets file:
   the `headersHelper` reads it on connect. Never inline the token, and never
   print it.

2. **Allow the MCP tools for this repo.** Merge into
   `.claude/settings.local.json` (create it if missing), preserving everything
   already present and adding only what is missing:

   ```json
   { "permissions": { "allow": ["mcp__ytmcp"] } }
   ```

   Check `git check-ignore .claude/settings.local.json`; if it is not ignored,
   tell the user (do not edit `.gitignore` unasked).

3. **Reload:** the user quits Claude Code and resumes with `claude --continue`.
   The `headersHelper` runs only in a trusted workspace, so if prompted, the
   user accepts the folder trust dialog.

### Opt-in: OpenCode

The `ytmcp` MCP is defined once in the global OpenCode config but disabled.
OpenCode V2 replaces a same-name MCP server object instead of merging it, so a
repo cannot flip `disabled` in its own config; it opts in with a marker file
instead.

1. **The marker is `.ytmcp.json`** (Phase 1, step 1) — nothing extra to write.
   The global `ytmcp-enroll` plugin enables the shared `ytmcp` server for any
   location that carries this file, so the repo never repeats the server's
   `type`, `url`, or token. The plugin still accepts the legacy
   `.opencode/ytmcp.json`, but never create it.

2. **Add the project permission rules.** Find the repo's project config and
   merge in place. Look, in order, for an existing `opencode.json` or
   `opencode.jsonc` at the repo root, then `.opencode/opencode.json`. Merge into
   whichever exists — **do not create a second project config beside it.** Only
   when the repo has no project config at all, create `.opencode/opencode.json`.
   Add these rules, preserving everything already present:

   ```json
   {
     "$schema": "https://opencode.ai/config.json",
     "permissions": [
       { "action": "skill", "resource": "youtrack-*", "effect": "allow" },
       { "action": "ytmcp_*", "resource": "*", "effect": "allow" }
     ]
   }
   ```

   The `ytmcp_*` rule stops every MCP call from prompting; without it the tools
   inherit the global `"*": "ask"`. The `skill` rule re-enables the `youtrack-*`
   skills, which the global config denies by default.

   Merge semantics: add only the missing rules. Never touch unrelated
   permissions, and in a `.jsonc` file preserve existing comments — edit the
   file, do not rewrite it as plain JSON.

3. **Reload:** the user runs `/restart` in the TUI. In V2 the server restart is
   sufficient; the client does not need to be relaunched.

## Phase 2 — Connect

Enter here when the MCP tools are available — including after the reload, when
the user says `continue`. If Phase 1 was skipped because the tools were already
present, still check whether the other harnesses are opted in and offer their
opt-in (Phase 1, step 3).

### 2a. Verify connectivity

Call `ytmcp.list_projects`. On an auth failure, stop and point at the token. On
success, continue.

### 2b. Find the project for this repo

1. Read the repo: the directory name, the name from `git remote` if there is
   one, and the top of the README or AGENTS.md / CLAUDE.md — these are your
   hints for what to look for.
2. `ytmcp.list_projects` → the list is small and rarely called, so reason about
   the best match directly. Propose the obvious single correct match, or the few
   best candidates.
   - **One match / an obvious match** → propose it and confirm.
   - **Several plausible** → ask which one.
   - **None** → ask how to proceed with the question tool, presenting:
     1. _I have created/shared it now — check again_ → repeat
        `ytmcp.list_projects` and find the project this time.
     2. _Create a new project_ → gather the details, then call
        `ytmcp.project_create`:
        - **name** — propose one from the repo (directory name / `git remote`),
          confirm.
        - **shortName** — propose an uppercase prefix derived from the repo,
          confirm.
        - **description** — propose a one-line description drawn from the README
          / AGENTS.md (what the project is), confirm.
        - **user** — the user's own YouTrack login or id (the handover target).
          Ask: the MCP token belongs to the Agent service account, not the user.
          The tool clones the shared "Init Template Board" as the project board
          and hands the project and board to that user. Then record the project.
     3. _Show all projects_ → list everything and let the user pick.

3. **Record the found project** in `.ytmcp.json` (its `project` field), so the
   `youtrack-*` skills know which project to operate on. Note the project's
   short name (e.g. `YTMCP`).

### 2c. Already set up

If a project is already recorded, tell the user it is already set up and ask how
to go on — there is a single cached value, so no reconciliation dance. It will
be corrected manually on the rare occasion a project is renamed.

## Tool surface

- `ytmcp.list_projects` — list the projects the token can access, so the repo
  can be matched to its project.
- `ytmcp.project_create` — create a project (cloning the shared "Init Template
  Board") and hand it over to a user; used only in the "create a new project"
  branch.

Call them the way your harness exposes them (shared conventions §7).

## Anti-patterns

- Applying an other harness's opt-in without asking.
- Recording the project in a harness-specific file instead of `.ytmcp.json`.
- Inlining, printing, or copying the token anywhere; it lives only in
  `~/.dotfiles/secrets/youtrack-token`.
- Putting the `ytmcp` server definition in a file inside the repo (OpenCode
  project config, `.mcp.json`); `.ytmcp.json` (the OpenCode marker) and the
  Claude Code local-scope entry are the only opt-ins.
- Creating the legacy `.opencode/ytmcp.json` marker; migrate it away instead.
- OpenCode: telling the user to quit and relaunch the whole client when
  `/restart` is sufficient.
- OpenCode: shelling out to `opencode service restart` from a tool — it restarts
  the background server hosting the session and kills the session mid-call. The
  agent cannot perform `/restart`; the user must run it.
- Calling the YouTrack REST API, or `curl`, directly.
- Creating a second project config beside an existing one instead of merging.
- Guessing the project instead of listing and confirming.
- Recording a project without confirming it with the user.
- Overwriting existing permissions or MCP servers while merging.
- Reporting success without having confirmed connectivity and the project.
