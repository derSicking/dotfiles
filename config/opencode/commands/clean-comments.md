---
description:
  Clean up comments across the codebase — remove obvious/verbose/conversational
  comments, trim doc comments, keep TODOs.
---

Clean up comments in the codebase. Follow these rules precisely:

## What to REMOVE

1. **Obvious-explanation comments** — comments that restate what the code does:
   - "Creates the app" above `pub fn new`
   - "Build a per-object transform: translate, then rotate, then scale" when the
     function name says it
   - Numbered step comments like "// 1. Load shader" / "// 2. Create module"
     when the code is self-explanatory
   - "Fetch-before-borrow: copy the action state, then mutate" when the code
     does exactly that

2. **Verbose doc comments** — paragraphs that could be sentences:
   - Module-level docs that repeat architecture info found in DESIGN.md
   - Struct field comments that just restate the field name/type
   - Method doc comments that rephrase the method signature

3. **Conversational/anecdotal comments** — context that doesn't help a future
   reader:
   - "the reported bug: ..." (the bug is fixed, the test covers it)
   - "This is the deliberate exception to the codebase's usual..." (design
     rationale belongs in DESIGN.md)
   - "E3 visual test" / "E4b proof" / "M7 test system" (milestone references
     become stale)

4. **Section divider comments** —
   `// ---------------------------------------------------------------------------`

5. **Redundant comments** — the same fact stated in multiple places (e.g.,
   "FontSystem shared across threads" in 5 files)

## What to KEEP

1. **Marked comments** — keep comments with a recognized marker prefix: `TODO`,
   `TEMPORARY`, `NOTE`, `IDEA`, `HACK`, `FIXME`, `XXX`, `REFACTOR`, etc. These
   encode intent, known limitations, or future work — they are not noise.
   Exceptions:
   - Remove a marker if the work is clearly done (the code now does what the
     marker describes).
   - Remove a marker if it describes something obsolete or wrong (the design
     changed, the bug was fixed and the test covers it).
   - If a comment references future work but lacks a marker, add one (`TODO:`
     etc.) rather than removing it.

2. **Architectural rationale** — "why" a design was chosen, not "what" the code
   does:
   - "The sim blocks on the message channel, so commands wake it immediately"
   - "FontSystem is shared via Arc<Mutex> because both threads need it"

3. **Non-obvious invariants** — things a reader wouldn't guess:
   - Alignment constraints ("row i of each column belongs to entities[i]")
   - Concurrency contracts ("no locks in either hot path")
   - Safety requirements ("caller must ensure no SurfaceTexture is alive")

4. **Module-level docs** that orient a new reader — but trim them to 2-4
   sentences max.

5. **Test documentation** explaining _what_ is being verified — but only when
   the test name isn't enough.

## Process

1. Work through files one at a time, starting with the largest/most-commented
   files.
2. For each file, read it fully, identify comments to remove, then edit.
3. After all edits, run `make build` and `make test` to verify nothing broke.
4. Present a summary of what was removed and what was kept.
