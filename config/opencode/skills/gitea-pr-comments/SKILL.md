---
name: gitea-pr-comments
description:
  Use when the user wants to work through, address, or answer review comments on
  a Gitea pull request — "address the PR comments", "fix the review findings on
  PR 12", "go through the bot's review", "reply to the review". Reads open
  review threads and conversation comments through a Gitea MCP server, fixes or
  answers each one in the local checkout, then replies on and resolves the
  threads after the user approves.
---

# Work through Gitea PR comments

Requires a `gitea` MCP server with the pull request and issue tools. Their exact
names depend on the harness: commonly `pull_request_read`,
`pull_request_review_write`, `issue_read`, `issue_write`, sometimes prefixed
with the server name (`gitea_pull_request_read`) or grouped under a code-mode
namespace (`tools.gitea.pull_request_read`). Discover the tools the way your
harness exposes them (tool search, the MCP server list, or the tool catalog in
your instructions) before concluding that they are missing. If they are missing
or fail to connect, tell the user to check the MCP server configuration and the
Gitea token it uses (often `GITEA_ACCESS_TOKEN` or a token file), then stop.

The write tools take an action argument in current gitea-mcp versions, for
example `pull_request_review_write` with `method: "reply_comment"`; older
versions expose one tool per action. Use whichever shape your server offers.

## 1. Find the PR

- Owner and repo: parse `git remote get-url origin` (e.g.
  `ssh://git@host:222/owner/repo.git` gives owner `owner`, repo `repo`).
- PR number: from the user's request. If none was given, use `pull_request_read`
  method `get_by_branches` (or `list_pull_requests`, if the server exposes it)
  to find the open PR whose head is the current branch, and confirm it with the
  user.
- Make sure the local checkout is on the PR's head branch and up to date
  (`git fetch`, `git status`). Do not switch branches with uncommitted changes
  without asking.

## 2. Collect what is open

- `pull_request_read` method `get_reviews`, then `get_review_comments` for the
  inline threads (path, line, body, author, resolved state, comment id).
- `issue_read` method `get_comments` with `issue_number` = PR number for the
  main conversation.
- Skip resolved threads and threads that are already answered with no follow-up.
  Comments by the review bot are findings like any other.

Show the user a numbered list: author, file:line, a one-line summary, and your
plan for each — **fix**, **answer** (no code change, e.g. the finding is wrong
or a question), or **ask** (needs their decision). Wait for confirmation or
adjustments before changing code.

## 3. Work the items

One item at a time, following the repository's own instructions (its
`AGENTS.md`, `CLAUDE.md`, or whichever instruction files it keeps: small diffs,
tests, build commands):

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
  `comment_id`; then `resolve_thread` only for items that are fixed or settled.
- Conversation comment: `issue_write` method `add_comment` on the PR number.

Never approve, request changes, dismiss reviews, merge, or close the PR unless
the user explicitly asks. Finish with a short summary: fixed, answered, still
open.
