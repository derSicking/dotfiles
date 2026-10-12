---
name: youtrack-capture
description:
  Use when the user wants to record an idea, user story, bug, or chore — "note
  this", "add a task", "remember this", "I want to track", or when they state a
  new requirement in passing. Captures it into the project's Backlog, searching
  first for an existing ticket to update or attach to and linking related
  tickets. Does not refine, size, or start work on the ticket.
---

# Skill: youtrack-capture

Record a thought into the tracker with minimal friction. This is the Intent
state: stay as close to the user's words as possible, add only context you
actually know, and never expand the idea.

**First, read the shared conventions:**
`~/.config/opencode/skills/_shared/youtrack-conventions.md`

## Preconditions

The `ytmcp_*` MCP tools must be present (e.g. the `ytmcp` server). If they are
missing, run `youtrack-init` to opt the repo in.

## Steps

1. **Understand the capture.** Restate it in one line. Decide the `type:`:
   - a concrete want or requirement; the user may be the developer (a dev tool
     or instrumentation affordance) → `user-story`
   - a loose thought → `idea`
   - something broken → `bug`
   - technical foundation or upkeep with no new affordance → `chore`

   Ask only when it is genuinely ambiguous. Default loose thoughts to `idea`.
   Keep it low-friction: a few quick follow-ups at most, and only about what
   context is welcome.

   Pick a fitting `area:` value (owned by the user — set the best fit, never
   create one). If none fits, leave it unset and suggest the user create one.

   You may add context you actually have: links to related tickets, the area of
   the code, why it came up, and a tidied title and description (fix grammar and
   spelling). You must not add design, expanded detail, or opinion, and you must
   not invent facts. When unsure whether a piece of context is welcome, ask.

2. **Search before creating — always.** `ytmcp_search` for the key nouns. Look
   for tickets that already cover it, larger tickets it belongs to, and tickets
   it is logically connected to. Present what you found and let the user choose
   a path:
   - **Update** an existing ticket when it already covers the thought.
   - **Attach** it to an existing ticket with a relation or comment —
     `ytmcp_link_add` (`subtask`/`depend`/`duplicate`/`relates`) or
     `ytmcp_comment_add`. This is the preferred outcome when there is a logical
     connection.
   - **Create** a standalone ticket, relating it to any connected tickets.
   - **Skip** it.

3. **Act on the choice.**
   - **Update:** edit the existing ticket so it covers the thought
     (`ytmcp_issue_update`), and report exactly what changed.
   - **Attach:** add the thought to an existing ticket — a comment
     (`ytmcp_comment_add`) or a relation (`ytmcp_link_add`) that expresses the
     connection.
   - **Create:** `ytmcp_issue_create` in the project. Title is the tidied
     statement. Description holds the user's words plus the known context.
     Attach the `type:` and `area:` fields. Leave it in Backlog — do not set a
     `size` or move to Ready. Add relations to any connected tickets.

4. **Confirm briefly:** ticket id and title, that it is in Backlog, and any
   relations created. Stop there.

## Rules

- Capture never refines: no `size:`, no acceptance criteria, no move to Ready.
- Never create a ticket without the search in step 2.
- Prefer attaching to an existing ticket when a logical connection exists.
- Reuse the best-fitting `area:` value; never create one (suggest instead).
- Add only context you actually know — no design, no expanded detail, no
  opinion.
- Set a priority only if the user states urgency; otherwise leave it unset.
- Never silently change the scope of an existing ticket.

## Anti-patterns

- Duplicating a ticket that already exists instead of updating or relating it.
- Creating a near-duplicate `area:` label when a fitting one already exists.
- Padding the description with design, expanded detail, or opinion.
- Asking questions that belong to refinement.
- Moving a ticket to Ready (`youtrack-refine`) or In Progress (`youtrack-pick`).
- Recording a vague title while dropping the context the user actually gave.
