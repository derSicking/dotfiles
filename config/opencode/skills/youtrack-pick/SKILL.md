---
name: youtrack-pick
description:
  Use when the user asks what to work on next — "pick a ticket", "what should I
  work on", "next task", "what is next", "start something". A decision skill
  that recommends the next step and enacts the choice. Proposes the top Ready
  candidates by priority (skipping blocked work), or — when nothing is ready —
  recommends refining the To Refine column, or promoting a Backlog issue to
  refine. Moves the chosen issue to In Progress.
---

# Skill: youtrack-pick

Decide what to work on next and enact that choice. Picking is a commitment: do
not pick something that cannot actually be finished, and never silently pile up
work.

**First, read the shared conventions:**
`~/.config/opencode/skills/_shared/youtrack-conventions.md`

## Preconditions

The `ytmcp_*` MCP tools must be present (e.g. the `ytmcp` server). If they are
missing, run `youtrack-init` to opt the repo in.

## Steps

1. **Read the board.** Read the Ready, In Progress, Backlog, and To Refine
   columns (`ytmcp_board`, scoped to the relevant states). Ready is the source
   of candidates; In Progress shows what is already underway; Backlog and To
   Refine feed the fallback recommendations.

2. **Flag work in progress first.** If In Progress is not empty, state what is
   there and ask whether to start another issue before finishing it. Never
   silently pile up work.

3. **Rank the Ready candidates.** Subgroup coherence applies (shared
   conventions §4): a Feature's priority is the ceiling for its subtasks.
   - A Feature carries no work, so it is never itself a candidate.
   - Group candidates by parent Feature using `ytmcp_features` (each Feature's
     priority plus its subtasks). A candidate with no parent forms its own group.
   - Order groups by priority (`Now` down to `Someday`; no priority last). Within
     a group, order subtasks by their own priority, descending along the
     Feature's dependency order — a subtask that depends on another ranks below
     it. A high-priority Feature's lower-priority subtask can therefore rank
     above another Feature's higher-priority subtask.
   - Skip any issue that is blocked by an unfinished issue, and say which
     blocker stops it (`ytmcp_issue_read` on links; a blocker counts as
     unblocked when it is done). Links are direction-aware.
   - Consider `Size` so the user can judge whether it fits the time available.

4. **Propose.** Present the top candidates — usually one to three — each with a
   one-line rationale: priority, size, area, and whether it is unblocked.
   Recommend one, then ask which to start. This is a `question` tool decision.

5. **Enact the choice.** Move the chosen issue Ready → In Progress with
   `ytmcp_issue_move(id, from="Ready", to="In Progress")` (the `from` guard
   catches stale memory). Confirm the issue id, title, and new column. The next
   step is `youtrack-work`.

6. **If Ready is empty**, recommend the next step instead of inventing one:
   - If `To Refine` has issues → suggest `youtrack-refine` to groom them to
     Ready.
   - If `To Refine` is also empty → suggest promoting a Backlog issue to To
     Refine by priority (Backlog → To Refine), for refining.
   - Only enact a promotion if the user chooses it.

## Rules

- Pick owns `Backlog → To Refine` and `Ready → In Progress`. Never move anything
  to Done.
- Never pick an issue blocked by unfinished work.
- One pick per invocation unless the user asks for more.
- Read the links before ranking; priority alone is not enough.
- Never move an issue the user did not choose.

## Anti-patterns

- Ranking on priority while ignoring a blocking relation.
- Starting new work without flagging existing In Progress work.
- Picking from Backlog because Ready was empty without saying so.
- Moving an issue to Done (`youtrack-verify` owns that transition, with user
  approval).
- Enacting a promotion the user did not ask for.
