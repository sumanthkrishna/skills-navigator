# 05 — Bottleneck Classification

## Bottleneck Categories

| Category | Signals |
|---|---|
| Requirements friction | Long gap from Jira In Progress to first commit |
| Coding complexity | Long time from first commit to PR creation with many commits |
| PR review delay | Long gap from PR creation to first review or approval |
| CI queue delay | Long time before Jenkins build starts |
| CI instability | Repeated failed builds or flaky tests |
| Sonar quality rework | Repeated Sonar failures before approval |
| Merge process delay | PR approved but not merged for long period |
| Deployment queue delay | Merge complete but Spinnaker not triggered |
| Deployment platform delay | Spinnaker pipeline slow or failing |
| Environment instability | Deployment succeeds but validation delayed or failed |

## Severity Example

| Severity | Rule of Thumb |
|---|---|
| Low | Delay under 30 minutes |
| Medium | Delay from 30 minutes to 4 hours |
| High | Delay from 4 hours to 1 business day |
| Critical | Delay over 1 business day or repeated failures |

## Recommended Output

The agent should explain:

- What happened
- Where time was lost
- Whether delay was human, system, or rework
- What action may reduce future delay
