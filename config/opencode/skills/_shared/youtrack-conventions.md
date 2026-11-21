# YouTrack workflow conventions

The shared contract for the `youtrack-*` skills. Read this file before acting.
It is not a skill; it carries no behaviour on its own.

## 1. The board and state model

The board is a Kanban over the `State` field. Columns:

```
Backlog → To Refine → Ready → In Progress → To Verify → Done
```

One task hierarchy, two levels: a `Feature` parent (which carries no work of its
own) and its subtasks (the actual work). No subtasks of subtasks; only Features
have subtasks.

A Feature is a bounded, finishable deliverable — a milestone you can point at
and call done — decomposed into work subtasks. It names a finishable outcome,
not a standing subsystem: a subsystem label (UI, Rendering, Engine) is an
`Area`, not a Feature. A Feature normally has at least two subtasks; what fits
in one work ticket is that ticket, not a Feature (e.g. the story `PROJ-42` "Add
undo to the editor", not the Feature "Editing"). A Feature may be created with
fewer than two subtasks when it is clearly a milestone whose subtask set will be
filled out during refinement, but by the time it is Ready it must have a
reasonable subtask set (at least two).

## 2. Lifecycle and transition ownership

State transitions belong to exactly one skill each:

| Skill            | Transitions                                                      |
| ---------------- | ---------------------------------------------------------------- |
| youtrack-capture | create the issue in Backlog, or record on an existing one        |
| youtrack-pick    | Backlog → To Refine; Ready → In Progress                         |
| youtrack-refine  | To Refine → Ready (or Obsolete / re-cut / split)                 |
| youtrack-work    | In Progress → To Verify                                          |
| youtrack-verify  | To Verify → Done (with user approval); back to To Refine / Ready |

Rules:

- `Done` is reachable only from `To Verify`, by `youtrack-verify` with the
  user's approval. It is never set from any other state.
- Every move is reported to the user.
- Never touch issues in In Progress, To Verify, or Done unless the workflow owns
  that transition.

## 3. Size

Size is relative, not absolute: it says how big an issue is _for its type_, on
no global scale.

- A work ticket (Bug, User-Story, Chore) may be any size through XL. XL is the
  edge: a work ticket that large is at the limit of one work session, just short
  of being split (or of the work becoming a Feature).
- A Feature is sized relative to other Features; it may be small next to a large
  one.
- Size is a judgement aid for splitting and scheduling. Never infer a type from
  a size, or a size from a type; the two are independent.

## 4. Priority

Priority encodes work order — when an issue is worked — not raw importance, and
not a mechanical function of the roadmap. The board sorted by priority is the
strongest determinant of what gets worked on.

Priority blends:

- roadmap order;
- enabler value — how much an issue unlocks or de-risks other work;
- subgroup coherence — issues in a connected Feature order sensibly relative to
  one another;
- strategic timing — high-value work that needs foundations waits; unglamorous
  enablers come early.

Links are reserved for hard dependencies and Feature/subtask grouping. Soft
usefulness is expressed through priority, never by linking every interaction.

Because of subgroup coherence, a high-priority Feature's lower-priority subtasks
may be worked before another Feature's higher-priority subtasks. Within a
Feature, its priority is a ceiling, not a blanket: subtasks carry their own
priorities, descending along the Feature's dependency order.

## 5. Definition of ready (per type)

`youtrack-refine` may move an issue to Ready only when the criteria for its
`Type` hold.

- Feature: design is sound; a bounded, finishable scope (not a subsystem
  bucket); a reasonable subtask set (at least two); dependencies recorded; no
  open questions.
- User-Story: concrete want + acceptance criteria; the user may be the developer
  — a dev tool or instrumentation affordance the developer can exercise is a
  User Story.
- Bug: repro steps + expected vs actual.
- Chore: a pure technical foundation or upkeep (refactor, performance,
  groundwork) with no new affordance the user or developer can exercise; the
  change and what it must not affect.
- Idea: not ready as-is; promote to a concrete type first.
- Common bar: tangible outcome; fits one work session (else split); dependencies
  recorded; not already covered.

Anything short of the bar stays in To Refine.

## 6. Definition of done (per type)

`youtrack-work` may move an issue to To Verify only when the criteria for its
`Type` hold. The common bar:

- The outcome is recorded as an issue comment: what shipped, and any deviations.
- The repo's own checks pass, using its documented commands.
- The user has been told what to validate by hand.

Per type:

- User-Story: acceptance criteria verified, including manual verification of the
  affordance via a concrete playbook the user can follow; changes committed with
  explicit approval.
- Bug: acceptance criteria verified; changes committed with explicit approval.
- Chore: the technical outcome is verified by automated tests and measurement
  (not a manual play test); no visible deliverable is required.

## 7. Tool surface conventions

These skills run under more than one agent harness (OpenCode and Claude Code).
They name things harness-neutrally; map them to your harness as follows.

The hosted MCP server is registered under the name `ytmcp`. The skills write a
tool as `ytmcp.<tool>` (e.g. `ytmcp.board`, `ytmcp.issue_move`). Call it the way
your harness exposes it:

| Harness     | How a tool is called                 | Permission name     |
| ----------- | ------------------------------------ | ------------------- |
| OpenCode V2 | Code Mode: `tools["ytmcp"].board(…)` | `ytmcp_board`       |
| Claude Code | the tool `mcp__ytmcp__board`         | `mcp__ytmcp__board` |

These skills use only the hosted server; they know nothing about any dev or
local variant of it.

A repo opts in per harness (`youtrack-init` sets this up). A repo that has not
opted in for the running harness has no `ytmcp` tools; run `youtrack-init`.

- OpenCode: the project record `.ytmcp.json` (below) doubles as the marker. The
  global `ytmcp-enroll` plugin enables the globally defined (disabled) `ytmcp`
  server for locations that carry it (the legacy `.opencode/ytmcp.json` is still
  accepted). The repo's project permission rules remain OpenCode's own opt-in.
- Claude Code: a local-scope `ytmcp` server entry for the repo (stored in
  `~/.claude.json`, private to the user), whose `headersHelper` reads the token
  from `~/.dotfiles/secrets/youtrack-token`.

The repo's YouTrack project short name is recorded, harness-neutrally, in
`.ytmcp.json` at the repo root (`{ "project": "YTMCP" }`). Read it before
calling project-scoped tools.

- Tools address issues by their text identifier (e.g. `YTMCP-14`) directly — no
  numeric-id resolution step.
- `project` is the first, required parameter of project-scoped tools (`board`,
  `features`, `search`, `issue_create` on the `ytmcp` server).
- Tools require token pass-through: the caller's `Authorization` bearer token is
  forwarded verbatim to YouTrack. Never log it.
- Field value sets (`Type`, `Priority`, `Size`, `Area`) are owned by the user.
  Set the best fitting available value; never create or edit the value sets. If
  no `Area` fits, leave it unset (falls back to `Area: General`) and suggest the
  user create a new one.
- Fail-safes: `ytmcp.issue_move` requires `from` (expected current state) and
  rejects `Done`; `ytmcp.link_add` rejects self-links and existing links;
  `ytmcp.issue_create` only accepts a `Feature` as `parent`.
- Generated content records the result, not the path. Ticket text, designs, and
  code carry only the actual target/goal, never the things that were discussed
  and decided against. Do not mention dropped or superseded ideas — they poison
  the context by reintroducing what was rejected. Exception: mention something
  only when a ticket genuinely needs to know _not_ to do a particular thing, or
  to _replace_ existing code.

## 8. MCP rules

- Use the `ytmcp` MCP tools only. Never call the YouTrack REST API directly, and
  never shell out to `curl` against the instance.
- Read a tool's description before calling it; never guess parameter names.
- If an operation genuinely has no tool, tell the user exactly what to do in the
  YouTrack UI. Do not improvise a workaround.

## 9. Working with the user

- Follow the repo's `AGENTS.md` / `CLAUDE.md`; this file never overrides
  repo-specific instructions.
- Every choice with more than one valid answer goes through the harness's
  question tool (`question` in OpenCode, `AskUserQuestion` in Claude Code), with
  options, tradeoffs, and a recommendation.
- Plan before acting; one concept per step; verify after each change using the
  repo's own commands, and quote the observed result.
- Never commit, push, or open a pull request without explicit approval.
