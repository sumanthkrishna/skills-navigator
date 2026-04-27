# 04 — Timeline Metrics

## Core Metrics

| Metric | Formula | Meaning |
|---|---|---|
| Story idle time | Jira In Progress → First Commit | Story picked but no code activity yet |
| Coding elapsed time | First Commit → PR Created | Approximate active build period |
| PR review wait | PR Created → First Review | Time waiting for human review |
| Approval wait | PR Created → PR Approved | Total approval latency |
| CI queue time | CI Queued → CI Started | Infrastructure wait |
| CI execution time | CI Started → CI Completed | Build/test runtime |
| CI rework time | CI Failed → Next CI Passed | Build/test failure recovery |
| Sonar rework time | Sonar Failed → Sonar Passed | Code quality remediation |
| Merge delay | PR Approved → PR Merged | Process delay after approval |
| Deployment wait | PR Merged → Deployment Started | Release/process queue delay |
| Deployment duration | Deployment Started → Deployment Succeeded | Pipeline runtime |
| Commit-to-deploy elapsed | First Commit → Deployment Succeeded | Full engineering flow duration |

## Classification

Group time into four high-level categories:

1. Active engineering time
2. Human wait time
3. Tooling / platform wait time
4. Rework time

## Important Caveat

First commit to PR creation is not a perfect measure of active work. Engineers may research, debug, collaborate, or wait on requirements before committing code. Use this as an approximation only.
