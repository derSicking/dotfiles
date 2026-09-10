---
description:
  Find and fix structural inconsistencies — split grab-bag modules, eliminate
  duplicated registration/setup, clarify module boundaries, add registration
  helpers.
---

Analyze the codebase for structural inconsistencies and clean them up. Follow
this process precisely:

## Phase 1: Exploration

### Git history scan

Before reading code, check the git log to find the last cleanup boundary:

1. Run `git log --oneline -30` to see recent commits.
2. Scan for the most recent commit whose message indicates a cleanup or refactor
   — look for keywords like "refactor", "reorganize", "split", "move",
   "extract", "rename", "cleanup", "clean up", "restructure", "consolidate".
3. If found, note its hash and date. Focus the analysis on files changed
   **since** that commit (`git diff --name-only <hash>..HEAD`). Files unchanged
   since the last cleanup are lower priority — they were already addressed or
   are not accumulating new debt.
4. If no cleanup commit exists, analyze the full codebase.

This avoids re-analyzing modules that were recently reorganized and keeps the
scope focused on current debt.

### Module tree mapping

Read the project's entry point (lib.rs, main.rs, or equivalent) to map the
module tree. Then read every module's public surface. For each file, note:

1. **What it contains** — types, traits, functions, constants
2. **What level it is** — engine/generic vs game-specific vs glue code
3. **Import direction** — what does it import from, what imports from it
4. **Naming** — does the file name match what's inside

## Phase 2: Issue Detection

Look for these specific patterns:

### Structural inconsistencies

- **Grab-bag modules** — files >500 lines mixing unrelated concerns (components
  AND systems AND utilities AND render logic in one file)
- **Naming mismatches** — a file named "scene" containing component definitions
  that belong in "ecs", or game systems living in an engine module
- **Split-personality modules** — a file module with subdirectory submodules
  (ui.rs containing pub mod button pointing to ui/button.rs) instead of the
  conventional directory-with-mod.rs

### Duplication

- **Registration/setup lists** — the same list of items registered in multiple
  places (e.g., component registration repeated in sim_loop, test helpers, and
  test setup)
- **Test helper duplication** — similar world/context creation helpers scattered
  across test modules
- **Import lists** — long import blocks repeated across files

### Coupling issues (only flag if the upside is questionable)

- Engine modules importing from game modules (usually wrong)
- Game modules importing from engine modules (usually fine)
- Bidirectional dependencies between modules
- Tight coupling where a generic interface would be simpler

### Missing utilities

- Constants or small functions defined locally that could be shared
- Repeated patterns (e.g., "register these 10 types") with no helper

## Phase 3: Plan

Present findings as a numbered list of issues, each with:

- What the problem is
- Why it hurts maintainability or readability
- A concrete fix (what moves where, what gets extracted, what gets renamed)

Ask the user to confirm the plan before making any changes.

## Phase 4: Execution

Work through the plan one step at a time:

1. Make one change (move a type, extract a function, rename a module)
2. Update all import sites
3. Run the project's build/check command
4. Run the project's test command
5. Only proceed to the next step if both pass

If a step requires multiple file edits, present the full set of changes before
applying them. After each step, briefly annotate what changed.

## Phase 5: Summary

After all steps, present:

- What was changed and why
- The new module structure (before/after)
- Any remaining issues that were intentionally deferred
- How many tests pass (before and after)
