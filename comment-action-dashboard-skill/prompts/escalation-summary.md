# Escalation Summary Prompt

From the action dashboard, identify items that need escalation.

Escalate when:

- Work is blocked for more than one business day
- Product clarification is missing
- Cross-team dependency has no owner
- Deployment or build failure blocks release
- Security/architecture concern is unresolved

Return:

| Escalation Level | Item | Reason | Needed Decision | Suggested Owner | Deadline |
|---|---|---|---|---|---|
