# 01 – Comment Signal Taxonomy

Use this taxonomy to classify comments into engineering action signals.

## Signal Categories

### 1. Blocker
Comments indicating work cannot continue.

Examples:
- Waiting on API contract
- Environment is down
- Missing credentials
- Test data unavailable
- Dependency team has not responded

Action pattern:
- Identify blocker owner
- Escalate if blocking sprint commitment
- Create a dated next step

### 2. Review Needed
Comments requesting review, approval, merge, or sign-off.

Examples:
- Can someone review this PR?
- Waiting for architecture approval
- QA sign-off pending
- Security needs to approve

Action pattern:
- Assign reviewer
- Set review deadline
- Track aging review requests

### 3. Build or Pipeline Failure
Comments related to failed builds, deployment issues, broken tests, or CI/CD failures.

Examples:
- Jenkins failed after latest commit
- Integration test broken
- Deployment failed in SIT
- Spinnaker rollback triggered

Action pattern:
- Assign fixing engineer
- Link failed job
- Determine whether failure blocks merge or release

### 4. Requirement Ambiguity
Comments showing unclear acceptance criteria, product behavior, API contract, edge cases, or expected output.

Examples:
- What should happen when customer has no account?
- Acceptance criteria does not mention retry logic
- Need PO clarification

Action pattern:
- Ask product/BA for decision
- Update Jira acceptance criteria
- Add test case once clarified

### 5. Design or Architecture Concern
Comments that challenge the technical approach.

Examples:
- This should be async instead of sync
- We need idempotency here
- This duplicates existing service logic
- Security risk with this token flow

Action pattern:
- Capture decision needed
- Route to architect/lead
- Convert unresolved discussion into decision record

### 6. Scope Creep
Comments adding new work beyond original story scope.

Examples:
- Can we also support bulk upload?
- Add dashboard changes too
- Include migration script in same PR

Action pattern:
- Separate required vs optional work
- Move extra scope to new story unless sprint-critical

### 7. Validation Needed
Comments indicating testing, QA, UAT, or data validation is incomplete.

Examples:
- Need QA to verify
- Test data is not ready
- UAT did not cover this scenario

Action pattern:
- Assign validation owner
- Define validation evidence
- Track completion before Done

### 8. Ready to Close
Comments indicating the work may be complete.

Examples:
- Verified in QA
- Merged and deployed
- Product accepted
- No further issues

Action pattern:
- Confirm criteria
- Close Jira or move to Done
- Capture deployment evidence
