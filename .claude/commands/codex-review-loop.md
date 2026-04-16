---
description: "Iteratively review and improve documents or plans using Ralph Loop + Codex parallel explorers. Use whenever the user wants to: review/audit a plan or markdown doc, check document quality or completeness, get a second opinion on technical writing, find gaps/risks/issues in a proposal or migration plan, or improve any .md file through multi-round AI review. Triggers on: 'review this doc/plan', 'audit this document', 'check this plan for issues', 'help me improve this README', 'review for completeness/feasibility/risk'. Works with plans in ~/.claude/plans/ and any .md file."
allowed-tools: ["Bash(ls:*)", "Bash(head:*)", "Bash(node:*)", "Bash(cat:*)", "Read", "Write", "Edit", "Glob", "Grep", "AskUserQuestion", "Skill(ralph-loop:ralph-loop)", "Skill(codex:rescue)"]
---

# Codex Review Loop — Ralph Loop + Codex Parallel Review

Iteratively review and improve documents/plans. Each round, Codex coordinates two parallel explorers that split the document into blocks, review independently, then merge findings. Ralph Loop drives multi-round iteration until the document passes or hits max iterations.

## Why parallel split-block review

A single pass over a long document tends to lose focus on later sections. Splitting into two blocks and reviewing in parallel gives better coverage — each explorer focuses on fewer sections with full attention, and the merge step catches cross-block inconsistencies.

## Execution

### Step 1: Identify the target document

If `$ARGUMENTS` contains a file path, use it directly. Otherwise:

1. Search `~/.claude/plans/*.md` and `.md` files in the current directory
2. Present candidates with `AskUserQuestion` — show filename and first-line title
3. Let the user pick

Read the full document. Confirm it exists and is non-empty.

### Step 2: Determine review focus

Ask the user which dimensions to review (use `AskUserQuestion` with multiSelect). Defaults:

1. **Completeness** — missing sections, gaps, unaddressed requirements
2. **Feasibility** — realistic approaches? clear dependencies? sound tech choices?
3. **Consistency** — internal logic, terminology, naming
4. **Risk** — unidentified risks, blind spots, missing fallbacks
5. **Clarity** — ambiguous language, poor structure

### Step 3: Write instructions file and launch Ralph Loop

Ralph Loop's setup script parses prompts as shell words — complex multi-line text breaks. Solution: write full instructions to a file, pass a short prompt to Ralph Loop.

Parse `--max-iterations` from `$ARGUMENTS` (default: 3).

**Step 3a**: Write `/tmp/codex-review-loop-instructions.md` with this content (fill in FILE_PATH and DIMENSIONS):

```markdown
# Codex Review Loop Instructions

Target: <FILE_PATH>
Review dimensions: <DIMENSIONS>

## Each iteration:

### 1. Read the document
Read <FILE_PATH> for the latest content.

### 2. Split document into two blocks
Divide the document roughly in half by sections/headings:
- Block A: first half of top-level sections
- Block B: second half of top-level sections

If the document is short (under 5 sections), give both explorers the whole document but assign different dimension focus (e.g., Explorer 1 does Completeness+Feasibility+Consistency, Explorer 2 does Risk+Clarity+cross-references).

### 3. Call Codex with parallel explorer coordination
Call Codex rescue. In the prompt, include the FULL document content and instruct Codex to:

"You are a review coordinator. Your job is to dispatch two parallel explorer agents, collect their results, and produce one merged report.

Split plan:
- Explorer 1 reviews: <Block A section names> focusing on <dimensions>
- Explorer 2 reviews: <Block B section names> focusing on <dimensions>
- Both explorers also check cross-references to the other block for consistency

Each explorer outputs issues in this format:
  Location | Problem | Suggestion | Severity (CRITICAL/SUGGESTED/MINOR)

After both explorers complete:
1. Merge their findings into one unified list, deduplicated
2. Add any cross-block inconsistencies (e.g., Block A promises X but Block B contradicts it)
3. Give overall verdict: PASS / NEEDS_WORK / MAJOR_ISSUES

Document to review:
<full document content>"

### 4. Log feedback
Append round summary to <FILE_PATH>.review.md:
- Round number
- Issues by severity (CRITICAL/SUGGESTED/MINOR counts)
- Verdict
- Each issue with location and suggestion
- Actions taken

### 5. Apply fixes or finish
- Verdict PASS + zero CRITICAL: output <promise>REVIEW COMPLETE</promise>
- Otherwise: fix CRITICAL and SUGGESTED issues in the document, proceed to next round

### Rules
- Each round MUST call Codex — no self-review
- Be surgical — only fix what Codex flagged
- If same issues keep recurring across rounds, note it and exit
```

**Step 3b**: Launch Ralph Loop

```
Skill("ralph-loop:ralph-loop", args: "Read /tmp/codex-review-loop-instructions.md and follow the instructions to review and improve a document --max-iterations <N> --completion-promise 'REVIEW COMPLETE'")
```

### Step 4: Final report

After Ralph Loop ends, show:
1. Rounds ran, total issues found vs fixed
2. Path to `.review.md` log
3. Remaining CRITICAL issues (if max iterations hit)
4. Diff summary of document changes
