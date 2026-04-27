# 06 – Engineer Direction Framework

Use this framework to turn dashboard rows into direct, respectful engineering instructions.

## Direction Format

```text
Context:
What story/PR this relates to and why it matters.

Current Signal:
What the latest comment indicates.

Action Needed:
Specific action expected from the engineer.

Definition of Done:
What evidence should be provided when complete.

Escalation Path:
Who to contact if blocked.
```

## Example

```text
Context:
PAY-1421 is at risk because the latest Jira comment says the API response contract is still unclear.

Current Signal:
Engineering cannot complete retry handling until the response schema is confirmed.

Action Needed:
Please connect with the API owner today, confirm the response fields and error codes, and update the Jira story acceptance criteria.

Definition of Done:
Jira has the confirmed schema, PR test cases reflect the agreed behavior, and the blocker comment is resolved.

Escalation Path:
If API owner does not respond by 3 PM, escalate to the tech lead and product owner.
```
