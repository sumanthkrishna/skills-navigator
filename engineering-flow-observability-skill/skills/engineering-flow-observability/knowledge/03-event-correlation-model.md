# 03 — Event Correlation Model

## Why Correlation Matters

Each system sees only part of the engineering flow. The agent must connect events from multiple systems into one timeline.

## Primary Correlation Key

Use Jira story ID as the main correlation key.

Example:

```text
PAY-1234
```

## Secondary Correlation Keys

| Key | Purpose |
|---|---|
| Repository name | Connect PR, builds, deployments |
| Branch name | Connect story to commit/PR |
| Pull request ID | Connect Git events and CI status |
| Commit SHA | Connect PR to build and Sonar |
| Build ID | Connect Jenkins to Spinnaker |
| Artifact version | Connect build to deployment |
| Pipeline execution ID | Connect Spinnaker deployment events |

## Event Model

Each event should be normalized into this shape:

```json
{
  "event_type": "PR_CREATED",
  "source_system": "GitHub",
  "timestamp_utc": "2026-04-27T13:30:00Z",
  "story_id": "PAY-1234",
  "repository": "payment-service",
  "actor": "masked-or-team-level",
  "metadata": {
    "pull_request_id": "812",
    "commit_sha": "abc123"
  }
}
```

## Suggested Event Types

```text
JIRA_IN_PROGRESS
FIRST_COMMIT
PR_CREATED
CI_QUEUED
CI_STARTED
CI_FAILED
CI_PASSED
SONAR_STARTED
SONAR_FAILED
SONAR_PASSED
FIRST_REVIEW
PR_APPROVED
PR_MERGED
DEPLOYMENT_QUEUED
DEPLOYMENT_STARTED
DEPLOYMENT_FAILED
DEPLOYMENT_SUCCEEDED
LOWER_ENV_VALIDATED
```
