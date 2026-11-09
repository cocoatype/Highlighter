---
name: app-store-release-notes
description: Draft App Store release notes for Black Highlighter by pulling completed issues from the release’s GitHub milestone and formatting them per the Black Highlighter release-notes style guide. Use when the user asks to write, draft, or generate App Store release notes, release notes for the app, or what’s new copy for a release.
allowed-tools: Bash(gh api:*), Bash(gh issue view:*), Bash(git branch:*), Bash(jq:*), AskUserQuestion
---

# App Store Release Notes

Draft App Store release notes for Black Highlighter (iOS, iPadOS, and macOS) from GitHub issues in `cocoatype/Highlighter`. Follow every step in order. Do not skip steps. Do not invent issues, features, or fixes that aren’t in the GitHub results.

## Step 1: Fetch Issues

Each release has a GitHub milestone named after its version (e.g., `26.0`), matching the release branch (`release/26.0`).

Determine the version:

- If the user named a version, use it.
- Otherwise, run `git branch --show-current`. If it matches `release/X.Y`, use `X.Y`.
- If neither gives a version, use `AskUserQuestion` to ask which version to draft notes for, offering the open milestones as options.

Look up the milestone number for that version:

```sh
gh api 'repos/cocoatype/Highlighter/milestones?state=all&per_page=100' \
  --jq '.[] | select(.title == "X.Y") | .number'
```

If there’s no matching milestone, **stop** and tell the user.

Fetch the milestone’s closed issues:

```sh
gh api --paginate 'repos/cocoatype/Highlighter/issues?milestone=<number>&state=closed&per_page=100' \
  --jq '.[] | select(.pull_request == null) | {number, title, type: (.type.name // null), state_reason, labels: [.labels[].name], body}'
```

**Always pass `--paginate`.** Without it, results stop at one page and silently drop the rest.

Then filter the results:

- **Keep** only issues with `state_reason` of `completed`. Issues closed as `not_planned` or `duplicate` did not ship.
- **Exclude** issues labeled `Selfish`. These benefit Cocoatype, not users (build tooling, signing, deploy fixes, Xcode updates), and never go in release notes.
- Note any `macOS` or `iPad` labels. These mark platform-specific changes (see step 4).

If no issues remain after filtering, **stop**. Tell the user there’s nothing to draft for this release and exit.

## Step 2: Group Issues

For each remaining issue:

- Issue type `Bug` → “Bug Fixes” section.
- Any other issue type (`Feature`, `Task`) → “What’s New” section.

If the issue has no type, decide from the title and body: a description of broken behavior goes in “Bug Fixes”; anything else defaults to “What’s New”.

## Step 3: Ask About a Headline Section

Most releases just have “What’s New” and “Bug Fixes”. A milestone release may have one major feature that deserves its own headline section above “What’s New”.

Use `AskUserQuestion` to ask:

> Does this release have a milestone feature that deserves its own headline section above “What’s New”?

Options (`AskUserQuestion` allows at most four):

- Up to three of the most significant “What’s New” candidates, labeled with the issue number and a short summary (e.g., `#123 — Auto-hidden words`). The user can name a different issue via “Other”.
- A final option: “No headline section — just What’s New and Bug Fixes”.

If the user picks an issue, remove it from “What’s New” and treat it as a headline section in step 5. If the user picks “No headline section”, skip the headline section.

## Step 4: Draft Bullets

For each issue, draft one bullet that follows the style guide below.

- Read the issue’s `title` and `body` to understand the user-facing impact. The title alone is often too implementation-flavored — the body usually has the user-facing detail.
- If the body is empty or too thin to write a good bullet, run `gh issue view <number> --repo cocoatype/Highlighter --comments` to get full context.
- If an issue is labeled `macOS` or `iPad` (and the change doesn’t apply everywhere), say so in the bullet, e.g., “On Mac, …” or “On iPad, …”.
- If you still can’t tell what the user-facing impact is, **do not invent one**. Set the issue aside and list it at the end under “Need more info” so the user can fill in the gap.

After drafting, self-check every bullet against the **Hard rules** below. If a bullet violates a hard rule, rewrite it before continuing.

## Step 5: Assemble and Present

Output the full release notes inline as a single fenced markdown block so the user can copy them directly. Use this structure:

```
[Headline Feature Name]
- One- to three-sentence introduction in “Introducing” voice. End with where the user can try it.

What’s New
- Bullet 1.
- Bullet 2.

Bug Fixes
- Bullet 1.
- Bullet 2.
```

- Omit the headline section entirely if step 3 returned “No headline section”.
- Omit “What’s New” or “Bug Fixes” if either has zero bullets — don’t print empty sections.
- Within each section, order bullets by **user impact** (your judgment), not by issue number.
- If any issues ended up under “Need more info” in step 4, list them after the release notes block under a plain “Need more info” heading with the issue number and title.

After the block, tell the user: “Reply with edits, or say ‘looks good’ to finish.” Stop. Do not iterate automatically — let the user drive the next round.

---

## Style Guide

Every bullet must follow these rules. These are not suggestions.

### Hard rules — never violate

- **Never use the word “now”** to indicate when a change takes effect. The reader already knows it’s a new release. Drop “now” or rephrase using imperative mood.
- **Never use first-person plural** (“we”, “our”, “us”, “our team”). Talk about the feature or the user instead.
- **Never write filler** like “Bug fixes and performance improvements” or “Various improvements”. Every bullet must name a specific change.
- **Never invent changes**. If the GitHub issue doesn’t say it, it doesn’t go in the notes.
- **Always use smart/curly quotes and apostrophes** (`’ “ ”`), never straight ones (`' " "`). Applies everywhere, including section headers like “What’s New”.

### Voice and tense

- **Active voice.** “Tapping Done closes the editing view.” Not “When Done is tapped, the editing view is closed.”
- **Full sentences** ending in a period.
- **Imperative mood** works well for “What’s New” bullets that describe a new capability. Example: “Scan a document to redact it right away.”
- **Address the user as “you”** when describing a benefit. That’s fine — it’s still about them, not us.

### Front-load the fix (Bug Fixes especially)

Lead with the surface or behavior so the reader scanning for their bug can find it fast.

```diff
- When you open the editing view on a small iPhone, the color picker is laid out properly.
+ The color picker in the editing view lays out correctly on every iPhone size.
```

### Describe the corrected behavior, not the broken one

```diff
- Auto-hidden words no longer create empty redactions on lines without a match.
+ Auto-hidden words redact only the lines that contain a match.
```

### Focus on outcomes

Tell the user what they can do or what they’ll notice, not what code changed.

```diff
- Add AddAutoRedactionsIntent to App Intents.
+ Add words to your auto-hidden words list from the Shortcuts app.
```

### Capitalization

- **Always write the app’s full name**, “Black Highlighter”. Never shorten it to “Highlighter”.
- **Capitalize** the paid tier: “Ultra Highlighter”.
- **Capitalize Apple product and app names**: Shortcuts, Photos, Files, Mac, iPhone, iPad.
- **Lowercase** features in running text, matching how the app describes them: auto-hidden words, redaction, search, document scanning, sharing.
- **In-product UI labels** match the app exactly, which uses title case: the `Scan Document` button, the `Auto-Hidden Words` screen, the `Search` button. Never use internal names (e.g., “Seek and Destroy”, “AutoRedactions”) — use the label the user sees.

### Milestone features (headline section only)

For the headline section, shift voice slightly:

- Open with “Introducing [Name]”.
- 1–3 sentences. A little more excited, still professional.
- End by pointing the user at where to try it.

Example:

```diff
- Auto-hidden words are supported. Add words to a list and they’ll be redacted automatically.
+ Introducing auto-hidden words, the fastest way to keep sensitive info out of your screenshots! Add names, addresses, or any word to your list, and Black Highlighter redacts them automatically every time you open an image. Find it in Settings under Ultra Highlighter Features.
```

### Concision

Cut backstory. Cut “We discovered that…”. Cut “This is fixed.”

```diff
- We discovered that when people opened an image with auto-hidden words turned on, there were cases where the app would add a redaction to every line, even ones with no matching words. This is fixed.
+ Auto-hidden words redact only the lines that contain a match.
```

### Example “What’s New” bullets

These are the target quality bar:

- The editing view closes with an X button, matching the rest of the app.
- Settings closes with an X button, so it’s easier to get back to your image.
- Add words to your auto-hidden words list from the Shortcuts app.

### Example “Bug Fixes” bullets

- Settings displays its title in the correct font.
- The color picker in the editing view lays out correctly on every iPhone size.
- Navigation titles display in the correct color in light mode.

---

## Final self-check before presenting

Before you print the assembled notes in step 5, scan every bullet and confirm:

1. No bullet contains the word “now”.
2. No bullet contains “we”, “our”, or “us”.
3. Every bullet is a full sentence with a period.
4. Bug Fix bullets describe the corrected behavior, not the broken one.
5. Each bullet maps to a real, completed, non-`Selfish` issue from step 1.
6. Every quote and apostrophe is curly.

If any bullet fails, rewrite it before showing the user.
