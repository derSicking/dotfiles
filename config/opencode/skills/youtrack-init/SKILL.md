---
name: youtrack-init
description:
  Use when the user asks to connect this repo to the YouTrack MCP — "set up
  youtrack", "connect this repo to youtrack", "init the board", or when the
  ytmcp tools are missing and a repo needs the opt-in. Writes the per-repo
  opt-in marker and the project permission rules, then connects the repo to its
  project via list_projects and records it. Idempotent, so rerunning reconciles
  rather than duplicating.
---

# Skill: youtrack-init

Connect a repo to the hosted ytmcp MCP and to the right YouTrack project, so the
`youtrack-*` skills can operate on it. This is the bootstrap that pick, refine,
capture, work, and verify all reference in their Preconditions ("run
`youtrack-init` to opt the repo in"). Always idempotent: running it again
reconciles rather than duplicating.

**First, read the shared conventions:**
`~/.config/opencode/skills/_shared/youtrack-conventions.md`

## Step 0 — Detect the phase

1. Note whether the `ytmcp` server's tools are available in this session
   (Code Mode exposes them as `tools["ytmcp"].*`).
2. Read the repo's project config (`opencode.json` or `opencode.jsonc` at the
   root, or `.opencode/opencode.json`).

- **MCP tools absent → Phase 1 (bootstrap).**
- **MCP tools present → Phase 2 (connect).**

## Phase 1 — Bootstrap the opt-in

The `ytmcp` MCP is defined once in the global config but disabled. OpenCode V2
replaces a same-name MCP server object instead of merging it, so a repo cannot
flip `disabled` in its own config; it opts in with a marker file instead. Until
the repo opts in _and_ opencode restarts, there is no way to reach YouTrack.

1. **Write the opt-in marker.** Create `.opencode/ytmcp.json` (make the
   `.opencode/` directory if needed), starting with an empty project — Phase 2
   fills it in:

   ```json
   { "project": "" }
   ```

   The global `ytmcp-enroll` plugin enables the shared `ytmcp` server for any
   location that carries this file, so the repo never repeats the server's
   `type`, `url`, or token.

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

3. Show the user the exact files after writing them.
4. **Stop** and tell the user: config is loaded at startup, so quit and relaunch
   opencode, then say `continue` to resume this skill.

If the MCP is still unavailable after restart, the global YouTrack MCP
definition or the token is wrong — point at the global config and the token
secret, and stop. Do not try to fix credentials yourself.

## Phase 2 — Connect

Enter here when the MCP tools are available — including after the restart, when
the user says `continue`.

### 2a. Verify connectivity

Call `tools["ytmcp"].list_projects(…)`. On an auth failure, stop and point at
the token. On success, continue.

### 2b. Find the project for this repo

1. Read the repo: the directory name, the name from `git remote` if there is
   one, and the top of the README or AGENTS.md — these are your hints for what
   to look for.
2. `tools["ytmcp"].list_projects(…)` → the list is small and rarely called, so
   reason about the best match directly. Propose the obvious single correct
   match, or the few best candidates.
   - **One match / an obvious match** → propose it and confirm.
   - **Several plausible** → ask which one.
   - **None** → ask how to proceed with the `question` tool, presenting:
     1. _I have created/shared it now — check again_ → repeat
        `tools["ytmcp"].list_projects(…)` and find the project this time.
     2. _Create a new project_ → gather the details, then call
        `tools["ytmcp"].project_create(…)`:
        - **name** — propose one from the repo (directory name / `git remote`),
          confirm.
        - **shortName** — propose an uppercase prefix derived from the repo,
          confirm.
        - **description** — propose a one-line description drawn from the
          README / AGENTS.md (what the project is), confirm.
        - **user** — the user's own YouTrack login or id (the handover target).
          Ask: the MCP token belongs to the Agent service account, not the user.
        The tool clones the shared "Init Template Board" as the project board
        and hands the project and board to that user. Then record the project.
     3. _Show all projects_ → list everything and let the user pick.

3. **Record the found project** in `.opencode/ytmcp.json` (its `project` field),
   so the `youtrack-*` skills know which project to operate on. Note the
   project's short name (e.g. `YTMCP`).

### 2c. Already set up

If a project is already recorded, tell the user it is already set up and ask how
to go on — there is a single cached value, so no reconciliation dance. It will
be corrected manually on the rare occasion a project is renamed.

## Tool surface

- `list_projects` — list the projects the token can access, so the repo can be
  matched to its project.
- `project_create` — create a project (cloning the shared "Init Template
  Board") and hand it over to a user; used only in the "create a new project"
  branch.

OpenCode V2 exposes these through Code Mode, so call them as
`tools["ytmcp"].list_projects(…)` and `tools["ytmcp"].project_create(…)`.

## Anti-patterns

- Calling the YouTrack REST API, or `curl`, directly.
- Creating a second project config beside an existing one instead of merging.
- Putting the `ytmcp` server definition (`type`/`url`) in a project config; the
  marker opts the repo in, and the server stays defined once in the global
  config.
- Guessing the project instead of listing and confirming.
- Recording a project without confirming it with the user.
- Overwriting existing permissions or MCP servers while merging.
- Reporting success without having confirmed connectivity and the project.
