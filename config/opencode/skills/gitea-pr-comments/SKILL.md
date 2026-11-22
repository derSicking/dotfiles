---
name: gitea-pr-comments
description: Use when the user wants to work through, address, or answer review comments on a Gitea pull request — "address the PR comments", "fix the review findings on PR 12", "go through the bot's review", "reply to the review". Reads open review threads and conversation comments via the gitea MCP server, fixes or answers each one in the local checkout, then replies on and resolves the threads after the user approves.
---

# Work through Gitea PR comments

Requires the `gitea` MCP server (tools `mcp__gitea__*`). If its tools are
missing or fail to connect, tell the user to check `claude mcp get gitea`
and the token file in its `GITEA_ACCESS_TOKEN_FILE`, then stop.

## 1. Find the PR

- Owner and repo: parse `git remote get-url origin`
  (e.g. `ssh://git@host:222/owner/repo.git` gives owner `owner`, repo `repo`).
- PR number: from the user's request. If none was given, use
  `pull_request_read` method `get_by_branches` (or `list_pull_requests`) to find
  the open PR whose head is the current branch, and confirm it with the user.
- Make sure the local checkout is on the PR's head branch and up to date
  (`git fetch`, `git status`). Do not switch branches with uncommitted changes
  without asking.

## 2. Collect what is open

- `pull_request_read` method `get_reviews`, then `get_review_comments` for the
  inline threads (path, line, body, author, resolved state, comment id).
- `issue_read` method `get_comments` with `issue_number` = PR number for the
  main conversation.
- Skip resolved threads and threads that are already answered with no
  follow-up. Comments by the review bot are findings like any other.

Show the user a numbered list: author, file:line, a one-line summary, and your
plan for each — **fix**, **answer** (no code change, e.g. the finding is wrong
or a question), or **ask** (needs their decision). Wait for confirmation or
adjustments before changing code.

## 3. Work the items

One item at a time, following the repository's own rules (AGENTS.md /
CLAUDE.md: small diffs, tests, build commands):

- **fix**: make the change, run the relevant tests or build, and note what you
  verified.
- **answer**: draft a reply with the reasoning and code references.
- If a finding turns out wrong after reading the code, say so in the reply
  instead of changing code.

Commit and push only as the repository's rules and the user allow — ask if
unsure. A reply that says "fixed" should point at the pushed commit.

## 4. Reply and resolve (after approval)

Show the user every reply you are about to post and which threads you will
resolve, then, once approved:

- Inline thread: `pull_request_review_write` method `reply_comment` with the
  `comment_id`; then `resolve_thread` only for items that are fixed or
  settled.
- Conversation comment: `issue_write` method `add_comment` on the PR number.

Never approve, request changes, dismiss reviews, merge, or close the PR
unless the user explicitly asks. Finish with a short summary: fixed,
answered, still open.
