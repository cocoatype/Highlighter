---
name: dispatch
description: Take a GitHub issue from cocoatype/Highlighter from start to an open pull request. Creates a dedicated worktree and branch for the issue, generates the project, implements the change, lints, builds, and tests it, then commits, pushes, and opens a PR that closes the issue. Run as `/dispatch <issue-number>`.
argument-hint: <issue-number>
disable-model-invocation: true
allowed-tools: Bash(gh issue view:*), Bash(gh pr list:*), Bash(gh pr create:*), Bash(gh repo view:*), Bash(git fetch:*), Bash(git worktree:*), Bash(git branch:*), Bash(git status:*), Bash(git diff:*), Bash(git log:*), Bash(git add:*), Bash(git commit:*), Bash(git push github issue/*), Bash(git rev-parse:*), Bash(git config user.name), Bash(mise:*), Bash(pwsh scripts/test.ps1), Bash(pwsh scripts/test-mac.ps1), Bash(xcrun simctl:*), Read, Edit, Write, Glob, Grep, EnterWorktree, ExitWorktree, AskUserQuestion
---

# Dispatch an issue

Take issue `#$ARGUMENTS` from `cocoatype/Highlighter` to an open pull request. Work only in the issue's own worktree, never in the main checkout, so several dispatches can run at once.

Follow the steps in order. The project's conventions are in `CLAUDE.md`. Read it before writing code and follow it.

## Step 1: Read the issue

If `$ARGUMENTS` is empty or isn't an issue number, ask which issue to dispatch and stop until you get one.

```sh
gh issue view <n> --repo cocoatype/Highlighter --comments --json number,title,body,state,labels,milestone,comments
```

- If the issue is closed, **stop** and say so.
- If a PR already exists for it, **stop** and link it: `gh pr list --repo cocoatype/Highlighter --head issue/<n> --state all`.
- Decide whether you can implement it as written. If it needs a product or design decision that the issue and its comments don't settle, ask with `AskUserQuestion` before you start. Ask only about real blockers, not choices with an obvious default.

## Step 2: Create the worktree

Find the current release branch. It's the repo's default branch, for example `release/26.2`:

```sh
gh repo view cocoatype/Highlighter --json defaultBranchRef --jq .defaultBranchRef.name
```

Fetch, then create the worktree on a new `issue/<n>` branch from the remote release branch. Its upstream is the **local** release branch, per `CLAUDE.md`:

```sh
git fetch github
git worktree add -b issue/<n> .claude/worktrees/issue-<n> github/<release-branch>
git branch --set-upstream-to=<release-branch> issue/<n>
```

If `.claude/worktrees/issue-<n>` already exists, a previous dispatch was interrupted. Reuse it, and check `git status` and `git log` there to see what was already done.

Switch the session into it with `EnterWorktree` and `path: .claude/worktrees/issue-<n>`. From here on, every command runs in the worktree.

## Step 3: Generate the project

The Xcode project and workspace are generated and not checked in, so a fresh worktree has neither:

```sh
mise trust
mise run spm-install
mise exec -- tuist generate --no-open
```

Use `--no-open`. `mise run generate` opens Xcode, which you don't want for every worktree. Regenerate the same way whenever you add or remove files, targets, or dependencies.

## Step 4: Implement

- Find the relevant code before changing it. Follow `CLAUDE.md`: new code goes in Capabilities modules, Factory for dependencies, Swift Testing for tests, file headers, import grouping, and no unstructured `Task { }`.
- For the author in new file headers, use `git config user.name`.
- If the issue has a to-do list, work through every item. If one turns out to be wrong or out of scope, leave it, and explain why in the PR.
- Add or update tests for behavior you change, where the code is testable.
- Keep the change to what the issue asks for. Note unrelated problems you find for the PR description instead of fixing them.

## Step 5: Lint, build, and test

```sh
mise run lint
pwsh scripts/test.ps1
```

`scripts/test.ps1` creates its own simulator and deletes it afterwards, so it's safe to run while other dispatches are testing. If the issue is labeled `macOS`, or the change touches Mac-only code, also run `pwsh scripts/test-mac.ps1`.

Fix any lint errors, build failures, or test failures your change caused, and run again. If a failure looks unrelated to your change, check whether it also fails on the release branch before deciding it isn't yours. After three rounds of fixes that don't get everything passing, stop fixing and go on. The PR is then opened as a draft (step 7).

## Step 6: Commit and push

Review `git diff` first. Stage only the files you meant to change; never stage generated files (`*.xcodeproj`, `*.xcworkspace`, `Derived/`).

Commit with a short imperative summary in the repo's style ("Factory PhotoRenderer", "Fix default zoom to safe areas"). Use several commits if the work splits naturally. End each message with the attribution lines Claude Code gives you.

Push without `-u`, so the upstream stays the release branch:

```sh
git push github issue/<n>
```

## Step 7: Open the pull request

```sh
gh pr create --repo cocoatype/Highlighter --base <release-branch> --head issue/<n> --title "<title>" --body "<body>"
```

- **Title:** the same style as a commit summary.
- **Body:** start with `Closes #<n>.` Then add a few lines on what changed, how it was tested (which scripts ran and their results), and anything left out or found along the way. End with the attribution lines Claude Code gives you for PRs.
- If the issue has a milestone, pass `--milestone "<title>"`.
- If lint, build, or tests still fail, add `--draft` and list the failures in the body.

Never merge the PR.

## Step 8: Report

Once the PR is open, clean up the worktree. The branch is pushed, so it can be checked out again whenever it's needed.

1. Leave the worktree with `ExitWorktree` and `action: "keep"`. `ExitWorktree` can't remove a worktree that was entered by `path`, so this step only returns the session to the main checkout.
2. Remove the worktree from the main checkout: `git worktree remove .claude/worktrees/issue-<n>`. Keep the local `issue/<n>` branch.

Never pass `--force`. If git refuses because the worktree has uncommitted changes, leave it in place and tell the user what's there. Skip the cleanup if the push or the PR failed, so the work isn't lost.

Tell the user, briefly:

- the PR link, and whether it's a draft
- what changed
- what ran (lint, iOS tests, Mac tests) and the results
- any decisions you made that they should check
