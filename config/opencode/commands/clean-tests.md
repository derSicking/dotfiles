---
description:
  Clean up tests — remove flaky/brittle/marginal tests, simplify over-detailed
  assertions, fix temp-dir issues.
---

Clean up the test suite. Follow these rules precisely:

## What to REMOVE

1. **Flaky tests** — tests that depend on external state:
   - Tests writing to shared temp directories without cleanup
   - Tests depending on filesystem state (config files, prior test runs, system
     fonts)
   - Tests with race conditions or timing dependencies
   - Tests that fail non-deterministically on CI

2. **Brittle tests** — tests that break on trivial changes:
   - Asserting exact counts that change when unrelated code is added/removed
     (e.g., "exactly 6 entities", "exactly 3 registered types")
   - Asserting exact numeric values that are implementation details (magic
     numbers, internal IDs, exact byte offsets)
   - Asserting exact ordering when only presence/absence matters

3. **Marginal/meaningless tests** — tests that test the language/runtime, not
   behavior:
   - Tests asserting a type implements a trait (Default, Copy, Send, Clone,
     etc.) with no behavioral check
   - Near-duplicate tests (same logic tested in two places)
   - Tests that just verify plumbing (e.g., "getter returns the value I set")

4. **Over-detailed assertions** — tests that assert MORE than what the test name
   promises:
   - Test named "culls items outside bounds" asserting exact position of
     surviving item
   - Test named "teleports on action" asserting exact hardcoded coordinates
   - Test named "replays deterministically" asserting exact per-step output
     values
   - Test named "one view per camera" asserting exact coordinate passthrough
   - Test named "round-trips" asserting every single field value
   - Test named "omits X" asserting exact format strings

## What to KEEP

1. **Core behavioral tests** — tests that verify the behavior their name
   promises:
   - "culls items" → assert count changed, not which specific item survived
   - "teleports" → assert state changed + invariants hold, not exact destination
   - "deterministic" → assert first run == second run, not exact values
   - "sequential IDs" → assert second > first, not exact numeric IDs

2. **Edge case tests** — tests that verify important invariants:
   - Empty input handling
   - Boundary conditions
   - Error/panic cases

3. **Integration tests** — tests that verify wiring between components:
   - Full user interaction lifecycles (input → processing → output)
   - State transitions across module boundaries

## Assertion principles

- **Assert what the test name promises, not more.** If the test is about
  culling, assert that culling happened (count changed), not which specific item
  was kept.
- **Prefer existence/range checks over exact values** when the exact value is an
  implementation detail. "greater than zero" is better than "exactly 0.0833"
  when testing "it moved".
- **One concern per test.** If you're testing behavior A AND behavior B, split
  into two tests.
- **Use the `question` tool** when unsure whether a test is brittle — ask the
  user.

## Process

1. Read all test files across the project.
2. For each test, classify it: meaningful+stable, flaky, brittle, marginal,
   over-detailed.
3. Remove flaky/marginal tests. Fix brittle/over-detailed tests by simplifying
   assertions.
4. After all edits, run the project's test suite twice to verify stability.
5. Present a summary of what was removed/fixed and why.
