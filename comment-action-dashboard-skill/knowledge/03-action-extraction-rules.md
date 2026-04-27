# 03 – Action Extraction Rules

Use these rules to convert comments into actionable engineering direction.

## Rule 1: Prefer the latest comment, but do not ignore history

The latest comment tells current state. Historical comments reveal repeated blockers, unresolved questions, and ignored risks.

## Rule 2: Every dashboard row must answer four questions

1. What is the current signal?
2. What action is needed?
3. Who should own it?
4. When should it be resolved?

## Rule 3: Extract explicit and implied actions

Explicit:
- “@Ravi please review this” -> Review action for Ravi

Implied:
- “Build still failing” -> Assign engineer to fix build
- “Need product clarification” -> Product decision required

## Rule 4: Detect aging and repeated comments

Repeated comments increase risk.

Examples:
- Same blocker mentioned 3 times
- Review request older than 2 days
- Latest comment says “still waiting”

## Rule 5: Separate signal from noise

Ignore:
- Thanks
- Acknowledged
- FYI without action
- Generic status chatter

Keep:
- Decisions
- Questions
- Blockers
- Approvals
- Failed validations
- Risk indicators

## Rule 6: Generate practical actions

Weak action:
- Follow up

Strong action:
- Ask API team to confirm response schema for `/accounts/{id}` by 3 PM today and update Jira acceptance criteria.

## Rule 7: Mark confidence

Use confidence levels:

- High: comment directly states the action
- Medium: action is strongly implied
- Low: action requires lead interpretation
