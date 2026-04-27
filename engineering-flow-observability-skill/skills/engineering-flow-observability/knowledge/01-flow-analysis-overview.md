# 01 — Flow Analysis Overview

## Purpose

Engineering work inside a sprint does not move in a straight line from story pickup to deployment. Time is spent across coding, reviews, failed builds, quality gates, deployment queues, approvals, and environment readiness.

This skill analyzes the journey from:

```text
Jira Story → Branch / Commit → Pull Request → CI Build → Sonar Gate → PR Approval → Merge → Spinnaker Deployment → Lower Environment Success
```

## What the Skill Should Answer

1. When did engineering activity begin?
2. When was the first commit created?
3. When was the pull request opened?
4. How long did CI wait in queue?
5. How long did CI run?
6. Did CI fail? If yes, how many times?
7. Did Sonar fail? If yes, when was it fixed?
8. How long did the PR wait for approval?
9. How long after approval did merge happen?
10. How long after merge did deployment begin?
11. How long did Spinnaker deployment take?
12. What was the total elapsed time from first commit to lower-env deployment?

## Key Principle

The goal is not to measure individual engineer productivity. The goal is to measure delivery-system friction.

Good use:

- Identify slow approvals
- Detect flaky builds
- Identify Sonar rework loops
- Find deployment queue delays
- Improve sprint predictability

Bad use:

- Ranking engineers
- Punishing failed builds without context
- Counting commits as productivity
- Comparing unrelated technical stories
