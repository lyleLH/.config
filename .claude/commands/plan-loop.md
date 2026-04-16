---
description: "Pick a plan file and start Ralph Loop to execute it"
allowed-tools: ["Bash(ls -lt /Users/hao92/.claude/plans/*.md*)", "Bash(head -5 /Users/hao92/.claude/plans/*)", "Read", "AskUserQuestion", "Skill(ralph-loop:ralph-loop)"]
---

# Plan Loop - Pick a plan, run Ralph Loop

Follow these steps exactly:

## Step 1: List recent plans

Run `ls -lt /Users/hao92/.claude/plans/*.md | head -10` to get the 10 most recently modified plan files.

## Step 2: Read plan titles

For each plan file, read the first 5 lines to extract the title (usually the first `#` heading). Use `head -5` on each file.

## Step 3: Let user pick

Use AskUserQuestion to present the plans as options. Show the plan title and modification date in each option label/description. Present the top 4 most recent plans (AskUserQuestion supports max 4 options; user can type "Other" for older ones).

## Step 4: Read the selected plan

Read the full content of the selected plan file.

## Step 5: Start Ralph Loop

Invoke the ralph-loop skill with the plan content as the prompt. Use this format:

```
Skill("ralph-loop:ralph-loop", args: "<plan content> --max-iterations 10 --completion-promise 'PLAN COMPLETE'")
```

Before invoking, ask the user if they want to customize `--max-iterations` or `--completion-promise`, or use the defaults (10 iterations, promise = "PLAN COMPLETE").
