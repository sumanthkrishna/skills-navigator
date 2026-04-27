# Comment Action Dashboard Skill

This skill converts comment noise from Jira stories and Bitbucket repositories into a clear engineering action dashboard.

## What it does

It reads the latest comments and discussion threads from:

- Atlassian Jira stories, bugs, tasks, and epics
- Bitbucket pull requests, commits, and repository comment threads
- Optional CI/CD context from Jenkins, Bitbucket Pipelines, or deployment tools

Then it produces:

- A prioritized action dashboard
- Owner-specific engineer direction notes
- Blocker and dependency summary
- Risk and escalation view
- JSON/CSV exports for automation

## Recommended folder structure

```text
comment-action-dashboard-skill/
  skill.yaml
  README.md
  knowledge/
    01-signal-taxonomy.md
    02-data-sources-and-api-flow.md
    03-action-extraction-rules.md
    04-prioritization-model.md
    05-dashboard-schema.md
    06-engineer-direction-framework.md
  prompts/
    action-dashboard-master-prompt.md
    jira-latest-comment-analysis.md
    bitbucket-pr-comment-analysis.md
    engineer-direction-note.md
    escalation-summary.md
  scripts/
    Invoke-CommentActionDashboard.ps1
    Convert-CommentsToDashboard.ps1
    Export-ActionDashboard.ps1
  examples/
    sample-action-dashboard.md
    sample-dashboard.json
```

## Core idea

The latest comment often contains the real sprint signal:

- “Waiting on API contract” means dependency risk.
- “Build is failing after merge” means delivery risk.
- “Need product clarification” means requirement risk.
- “Can someone review?” means review queue action.
- “Blocked by environment” means platform escalation.

This skill turns those comments into action rows that a lead can use to direct engineers.

## Example output

| Priority | Source | Item | Latest Signal | Action | Owner | Due | Status |
|---|---|---|---|---|---|---|---|
| P1 | Jira | PAY-1421 | API contract still unclear | Schedule API alignment and update acceptance criteria | Tech Lead + API Owner | Today | Blocked |
| P1 | Bitbucket PR | payments-service#87 | Build failing on integration tests | Assign engineer to fix failing test and rerun pipeline | PR Owner | Today | At Risk |
| P2 | Jira | PAY-1440 | Waiting for QA data | Provide test data or unblock QA env | QA + Dev Owner | Tomorrow | Waiting |

## Usage

1. Configure environment variables for Jira and Bitbucket.
2. Run the PowerShell script.
3. Review generated dashboard and direction notes.

```powershell
./scripts/Invoke-CommentActionDashboard.ps1 `
  -JiraBaseUrl "https://your-domain.atlassian.net" `
  -JiraJql "project = PAY AND sprint in openSprints()" `
  -BitbucketWorkspace "your-workspace" `
  -Repositories "payments-service,customer-service" `
  -LookbackDays 14
```

## Authentication

Use environment variables or a secure secret manager. Do not hard-code tokens.

```powershell
$env:JIRA_EMAIL="you@company.com"
$env:JIRA_API_TOKEN="***"
$env:BITBUCKET_USERNAME="your-user"
$env:BITBUCKET_APP_PASSWORD="***"
```

## Leadership value

This dashboard gives engineering leaders a practical operating view:

- What needs action today?
- Who owns the next step?
- What is blocked?
- Which comments indicate hidden risk?
- Where should the lead intervene?
