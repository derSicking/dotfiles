---
name: youtrack-refine
description:
  Use when the user wants to groom, triage, or refine the backlog — "refine the
  backlog", "groom tickets", "triage", "what is stale", "get things ready". For
  each To Refine ticket it validates the described problem against the live
  board and the relevant repos, proposes promoting loose ideas, splitting
  oversized tickets, re-cutting a Feature's subtask set, adding relations,
  sizing and prioritising, and marking what is obsolete. Moves a ticket to Ready
  only when it meets the definition of ready.
---

# Skill: youtrack-refine

Make "Ready" mean something. The current, unrefined ticket is a proposal to be
checked against reality — the codebase is the evidence — never a commitment. A
Ready ticket, by contrast, is trusted: it carries only what was actually agreed.

**First, read the shared conventions:**
`~/.config/opencode/skills/_shared/youtrack-conventions.md`

## Preconditions

The `ytmcp_*` MCP tools must be present (e.g. the `ytmcp` server). If they are
missing, run `youtrack-init` to opt the repo in.

## Scope

Operates **primarily on the To Refine column**. It never moves a ticket to In
Progress, To Verify, or Done. In Progress work may be noted but is left alone.

It may also look at the **Backlog** column to suggest promoting items into To
Refine — especially when To Refine is empty or nearly empty, so refinement
always has something to work on.

## Operating model

Two levels: a `Feature` parent (no work of its own) and its subtasks (the actual
work). No subtasks of subtasks.

A Feature is a bounded, finishable deliverable, not a standing subsystem bucket;
a subsystem label (UI, Rendering, Engine) is an `Area`, not a Feature. It
normally has at least two work subtasks. When a Feature is still a stub — created
as an obvious milestone whose subtasks are not yet cut — refinement fills the set
out; by Ready it must have a reasonable subtask set (at least two).

- **Work tickets** (Bug, User-Story, Chore, Idea) — refined individually →
  Ready.
- **Feature tickets** in To Refine — refine means reviewing the feature's design
  and usefulness, and reviewing its whole subtask set (including subtasks still
  in Backlog): are they reasonable, do they need re-cutting, are new ones
  needed, or should some be marked obsolete? The Feature moves to Ready once its
  design is sound, its scope bounded and finishable, and its subtask set
  reasonable. Its subtasks are refined separately, not here.

## Scepticism

Nothing about a ticket is set in stone. Question **every part** of every issue —
the summary, the type, the priority, the size, the area, the relations, the
premise behind it, and the issue's very existence. A ticket may be re-cut,
rewritten, promoted, split, re-scoped, or dropped entirely. Do not treat any
existing text as authoritative; it was written by someone (or an agent) and may
never have been approved. The codebase and the board are the evidence, not the
ticket.

## Steps

1. **Choose the scope.** Ask what to refine: the whole To Refine column, one
   `Area`, the oldest tickets, or a single ticket. If the set is large, propose
   a bounded slice and say so. When To Refine is empty or nearly empty, expand
   the scope to suggest promoting candidates from Backlog into To Refine.

   **Default to one issue at a time.** Refinement is a discussion with the user
   about a single ticket, focused on that ticket in isolation, and you do not
   move on until it is settled and approved. The exceptions where you work a set
   rather than one issue are:
   - **Broad backlog refinement** — the goal is choosing from a pool of issues
     (e.g. which to promote or prioritise), not fleshing out one.
   - **Feature refinement** — the goal is ensuring the subtask set makes sense,
     not examining each subtask in detail.

2. **Gather.** Read the target tickets — `ytmcp_board` scoped to To Refine (or
   `ytmcp_search`) to find them, then `ytmcp_issue_read` for each one's full
   detail: description, comments, subtasks, and links. For a Feature, read its
   whole subtask set (`ytmcp_features` or the subtasks field). When suggesting a
   promotion, gather the Backlog candidate the same way. Check for duplicates.

3. **Validate against reality.** For every ticket:
   - Does the described problem or gap still exist? Is it already implemented or
     superseded?
   - Check the board for duplicates/coverage — does another ticket already cover
     it?
   - Check the relevant repos — confirm the referenced files, APIs, and
     behaviour are real.
   - Challenge the ticket's own framing: is the type right? Is the scope right?
     Should it even exist?
   - Derive the ticket's requirements from its use cases, sort them **Must /
     Defer / Drop**, and get the user's explicit verdict on each. A ticket is
     not ready while its requirements are unsettled.
   - "Could not verify" is a valid, honest finding. Never invent a conclusion
     about code you did not read.

4. **Build a proposal.** Classify each ticket and propose concrete changes:

   | Verdict        | Meaning                                                                            |
   | -------------- | ---------------------------------------------------------------------------------- |
   | `ready`        | already meets the definition of ready                                              |
   | `promote`      | `idea` → a concrete type, rewritten with intent and acceptance criteria            |
   | `re-cut`       | a Feature's subtask set needs restructuring                                        |
   | `split`        | a work ticket too big for one session → sibling subtasks under the same parent     |
   | `relate`       | connect to a ticket it depends on or duplicates                                    |
   | `requirements` | settle Must / Defer / Drop with the user's verdict                                 |
   | `size`         | propose `s`, `m`, or `l`                                                           |
   | `prioritise`   | propose a priority for ordering                                                    |
   | `blocked`      | record what it waits on                                                            |
   | `obsolete`     | superseded, wrong, or no longer wanted → State: Obsolete                           |
   | `new`          | create a new ticket — the refinement's conclusion spawns a different piece of work |

   Detailed API / data-shape design is **not** part of refine — that belongs to
   `youtrack-work`. Refine settles requirements and the concrete want so work
   can start immediately.

   `new` is valid on its own: the conclusion of refinement may be "this idea
   dies (→ obsolete), but it points at a different, better idea" — create that
   new ticket. A genuinely new idea may warrant handing off to
   `youtrack-capture` rather than creating it here.

   Present the whole proposal as a table and let the user approve, edit, or
   reject it item by item. Do not apply anything before that.

5. **Apply the approved changes.** `ytmcp_issue_update` for text/DoD and the
   `type`/`priority`/`size`/`area` fields; `ytmcp_issue_create` for new/split/
   promote parts; `ytmcp_link_add` for relations; `ytmcp_comment_add` for
   evidence (especially when marking obsolete); `ytmcp_issue_move` for To Refine
   → Ready / Obsolete, and Backlog → To Refine for a promotion.

6. **Report** a summary: promoted, re-cut, split, related, requirements settled,
   sized, prioritised, obsolete, moved to Ready, created, and anything left
   unresolved.

## Rules

- **Never move a ticket without the user's explicit approval.** A ticket moves
  to Ready (or Obsolete / Backlog → To Refine) only after the user has reviewed
  and approved the refined content. The proposal (step 4) is a draft; it becomes
  actionable only once the user signs off on it. Do not promote, move, or edit
  any ticket, and do not apply any change, before that approval.
- To Refine → Ready (or Obsolete / handled), and Backlog → To Refine for a
  promotion. Never In Progress, To Verify, or Done.
- Read the code before judging; do not refine on vibes.
- Work one issue at a time by default; discuss it with the user and get approval
  before moving to the next.
- Every split, re-cut, obsolete, promotion, move, or new ticket needs user
  approval first.
- Prefer a relation over a duplicate, always.
- Keep one hierarchy level: splitting a work ticket adds siblings under its
  parent; never create subtasks of subtasks.
- Set `type`, `priority`, `size`, and `area` to the best fitting available
  value. If no `area` fits, leave it unset and suggest the user create a new
  area value.
- Generated content records the result, not the path. Ticket text, designs, and
  code carry only the actual target/goal, never the things that were discussed
  and decided against. Do not mention dropped or superseded ideas. Exception:
  mention something only when a ticket genuinely needs to know _not_ to do a
  particular thing, or to _replace_ existing code.

## Anti-patterns

- Moving a ticket to Ready without the user's explicit approval of the refined
  content.
- Promoting or editing a ticket before the user has reviewed the proposal.
- Refining several tickets at once without agreeing the scope first.
- Moving to Ready without validating against the code/board.
- Trusting the ticket's existing text as fact instead of questioning it.
- Rewriting the user's intent into your own design.
- Refining a Feature by individually refining every subtask instead of reviewing
  the set.
- Creating nested subtasks (subtasks of subtasks).
- Dropping a ticket silently.
- Touching In Progress, To Verify, or Done work.
