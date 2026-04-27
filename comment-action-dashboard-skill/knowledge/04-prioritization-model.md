# 04 – Prioritization Model

Prioritize actions using urgency, risk, dependency, and sprint impact.

## Priority Levels

### P0 – Production / release critical
Use when:
- Production issue
- Release blocked
- Security issue
- Failed deployment affecting users

### P1 – Sprint commitment at risk
Use when:
- Story is blocked
- PR cannot merge
- Build failing
- Requirement unclear and work cannot proceed
- QA cannot validate

### P2 – Needs attention soon
Use when:
- Review pending
- Minor test issue
- Decision needed but not blocking yet
- Dependency may delay later work

### P3 – Track / cleanup
Use when:
- Documentation needed
- Follow-up improvement
- Optional refactor
- Non-blocking comment thread

## Scoring Model

| Factor | Score |
|---|---:|
| Blocks active sprint work | +3 |
| Blocks release or deployment | +4 |
| Latest comment includes “blocked”, “failing”, “urgent”, “waiting” | +2 |
| More than 2 repeated comments | +2 |
| Cross-team dependency | +2 |
| No owner identified | +1 |
| Aging more than 2 business days | +1 |

Suggested mapping:

- 7+ = P0/P1
- 4–6 = P1/P2
- 1–3 = P2/P3
