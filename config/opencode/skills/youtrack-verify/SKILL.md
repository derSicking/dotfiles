---
name: youtrack-verify
description:
  Use when a ticket is in To Verify and the user wants to confirm it is done —
  "verify this", "check the DoD", "what's in To Verify", "mark it done". The
  agent checks the definition of done, runs the automated tests, hands over a
  manual-test playbook, and applies small fixes. Makes the final To Verify to
  Done move with the user's approval.
---

# Skill: youtrack-verify

Help the user confirm that a ticket in To Verify is actually done, and move it
to Done once the user is satisfied. This is the verification step (the
`To Verify → Done` transition). The agent does the verification it can, then
performs the final move with the user's explicit approval.

**First, read the shared conventions:**
`~/.config/opencode/skills/_shared/youtrack-conventions.md`

## Preconditions

The `ytmcp_*` MCP tools must be present (e.g. the `ytmcp` server). If they are
missing, run `youtrack-init` to opt the repo in.

## Steps

1. **Read the ticket.** `ytmcp_issue_read` — description, definition of done,
   comments, links. The DoD depends on the ticket's `Type` (per the shared
   conventions): User-Story acceptance criteria include manual verification of
   the affordance; Bug needs its acceptance criteria verified; Chore's technical
   outcome is verified by automated tests and measurement, not a manual play
   test.

2. **Verify what the agent can.** Check each item of the DoD against the code
   and the running product. Run and interpret the repo's automated tests. Report
   pass/fail per item, flagging anything that fails. "Could not verify" is an
   honest finding — say what you could and could not check.

3. **Hand over a manual-test playbook.** Give the user concrete steps to test
   the functionality by hand and confirm what automated checks can't. Keep it
   focused: the specific behaviour to try, what a passing result looks like, and
   what to check if it fails.

4. **Resolve small fixes.** If verification surfaces a quick fix, apply it as
   part of the verification (with approval) and re-run the relevant checks. A
   larger gap or rework is not a quick fix.

5. **Recommend the next move.**
   - All checks pass → ask for the user's approval to mark it Done, then make
     the move (`ytmcp_issue_move(id, from="To Verify", to="Done")`). The user
     approves; the agent performs the mechanical move.
   - A larger gap or rework → recommend moving the ticket back to To Refine or
     Ready (`youtrack-refine`), rather than Done.

## Rules

- `To Verify → Done` is made with the user's explicit approval; never without
  it. `Done` is reachable only from `To Verify`.
- Small fixes may be applied as part of verification; larger rework goes back to
  To Refine or Ready.
- Read the ticket's DoD before judging; verify against the code and the running
  product, not on vibes.
- Report pass/fail per DoD item; say honestly what could not be verified.
- Tell the user what to validate by hand — automated checks miss what a human
  sees.

## Anti-patterns

- Marking a ticket Done without the user's explicit confirmation.
- Claiming a DoD item passes without having checked it.
- Handing over a vague playbook instead of concrete manual-test steps.
- Bundling a large rework into "verification" instead of sending it back to
  refine.
- Moving a ticket to Done that does not meet its definition of done.
