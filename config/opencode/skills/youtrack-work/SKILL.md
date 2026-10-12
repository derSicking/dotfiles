---
name: youtrack-work
description:
  Use when starting or continuing real work on a ticket — "work on ticket X",
  "implement this", "continue the current ticket". Carries a ready ticket from
  understanding to the To Verify column. Does a light sanity check, designs and
  plans at work-time, works one concept at a time with continual re-validation
  against the live code, records the outcome, and moves In Progress to To
  Verify. Does not redo refinement's requirements work. Use youtrack-refine to
  groom tickets instead of working them.
---

# Skill: youtrack-work

Carry a ready ticket from understanding to the To Verify column. Refinement
already settled the requirements and the concrete want; work starts from there
and carries the ticket through, keeping it true to the code along the way.

**First, read the shared conventions:**
`~/.config/opencode/skills/_shared/youtrack-conventions.md`

Then read the repo's own rules — `AGENTS.md`, a teaching guide, `CONTRIBUTING`,
anything equivalent. They override this skill wherever they disagree.

## Preconditions

The `ytmcp_*` MCP tools must be present (e.g. the `ytmcp` server). Work accepts
a ticket that is Ready or In Progress. If the user asks to work a specific
ticket, just work it — advance it to In Progress as needed, no need to run
`youtrack-pick` first. Pick is a standalone helper for choosing what to work on
when the user does not know, not a gate here. If the ticket is in To Refine or
Backlog, `youtrack-refine` comes first — say so rather than skipping that gate.

## Phase 0 — Light sanity check

Refinement has already settled the requirements and the concrete want. Work does
**not** redo that. But it does check the ticket is still true:

1. **Establish the baseline.** `git log`, `git status`, and the repo's own
   checks. Find the documented commands (Makefile, package scripts, task runner)
   rather than assuming them. Note the passing state.
2. **Read the ticket.** `ytmcp_issue_read` — description, DoD, comments, links.
   Confirm it is actually Ready (or In Progress) and its premise still matches
   the code. If the gap changed, the requirements are stale, or the design is
   invalid, **stop and hand back to `youtrack-refine`** rather than building on
   stale premises.

## Phase 1 — Design and plan at work-time

The detailed API / data-shape design belongs here, not in refine:

3. **Settle the shape first.** Design the API and data shapes from the settled
   requirements. Write the call sites down before writing the code. Work that
   discovers its API during implementation churns.
4. **Verify claims instead of asserting them.** API questions get real docs;
   performance questions get measured numbers; uncertain behaviour gets a
   throwaway probe in scratch space.
5. **Record the accepted design on the ticket before writing code.** Put the
   design and the files to change into the ticket (description or a design
   comment), and keep it current as decisions land. The ticket is the record. Do
   not record what was decided against.
6. **Present numbered steps sized for learning**, one concept each, each with
   its own verification. Order them so a thin slice reaches the running product
   as early as the design allows. Get explicit approval before starting.

## Phase 2 — Implement and teach

7. **One concept per step; never batch.** After each step, in conversation with
   the user, annotate what changed and why, and verify with the repo's own
   commands before moving on. Quote the observed result **in conversation** —
   test counts, command output, a real run. None of this goes into a ticket
   comment; it is the live back-and-forth with the user.
8. **Explain the reasoning, not just the change.** Walk through alternatives
   considered and tradeoffs made, and their consequence, **in conversation**. In
   code, match the repo's comment style; do not restate documentation in
   comments, and keep superseded context out of comments (per the conventions).
9. **Continually re-question.** Validate every claim and design from the ticket
   against the live code as you go: verify APIs/behaviour are real, check
   assumptions hold, keep the ticket's record current.
10. **Let the user try first when they seem keen.** Otherwise write the draft
    and walk through it. Offer a review pause before the next step; if the user
    says they will review, stop and wait.

## Phase 3 — Verify and finish

11. **Record the outcome.** Add a comment (`ytmcp_comment_add`) stating what
    shipped and any deviations, before the move.
12. **Move to To Verify.**
    `ytmcp_issue_move(id, from="In Progress", to="To Verify")` (the `from` guard
    catches stale memory; Done is reachable only from To Verify, by
    `youtrack-verify`). Tell the user what to validate by hand — checks miss
    what a human sees. The next step is `youtrack-verify`.

## Rules

- The ticket is a proposal; validate it against the code before building.
- Refinement settled the requirements; work does not redo them, but does a light
  sanity check and hands back to refine if the ticket is no longer ready.
- Work accepts a Ready or In Progress ticket; no need to run pick when the user
  names a specific ticket.
- Every design choice goes through the `question` tool with options and a
  recommendation.
- One concept per step; verify after each with the repo's commands.
- Never commit, push, or open a PR without explicit approval.
- Work owns `In Progress → To Verify`; Done is reachable only from To Verify, by
  `youtrack-verify` with user approval.
- If the work outgrows the ticket, stop and say so: update the ticket, or spawn
  and link new tickets, rather than silently expanding scope.

## Anti-patterns

- Building exactly what a vague ticket says without checking it is still true.
- Re-doing refinement's requirements/design instead of starting on the settled
  work.
- Inheriting requirements nobody accepted.
- Discovering the API during implementation instead of settling it first.
- Batching steps; "while we're at it" is where the work and the learning die.
- Claiming success without having run the check.
- Committing or pushing without approval.
- Leaving the ticket stale while the code moves on.
- Moving a ticket to Done (`youtrack-work` moves to To Verify only).
- Recording what was decided against in the ticket.
