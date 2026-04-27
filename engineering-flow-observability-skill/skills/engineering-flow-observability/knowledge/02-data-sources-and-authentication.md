# 02 — Data Sources and Authentication

## Required Systems

| System | Required Data | Example Token Variable |
|---|---|---|
| Jira | Story status changes, sprint, assignee, linked issues | `JIRA_TOKEN` |
| GitHub / Bitbucket | Commits, branches, PRs, approvals, merge events | `GITHUB_TOKEN` / `BITBUCKET_TOKEN` |
| Jenkins | Build queue time, start/end time, build result, test status | `JENKINS_TOKEN` |
| SonarQube | Quality gate result, code smell/security/coverage result | `SONAR_TOKEN` |
| Spinnaker | Deployment pipeline start/end/status/environment | `SPINNAKER_TOKEN` |
| Confluence | Publishing reports and sprint summaries | `CONFLUENCE_TOKEN` |

## Authentication Pattern

Use environment variables. Never hardcode tokens.

```powershell
$Headers = @{
  "Authorization" = "Bearer $env:GITHUB_TOKEN"
  "Accept" = "application/json"
}
```

## Recommended Correlation Fields

Use a consistent key across all tools.

Preferred format:

```text
JIRA-STORY-ID in branch name, commit message, PR title, and deployment metadata
```

Example:

```text
feature/PAY-1234-add-payment-validation
PAY-1234: Add payment validation
PR Title: PAY-1234 - Add payment validation
Spinnaker Trigger: PAY-1234 / payment-service / build-456
```

## Security Notes

- Use least-privilege tokens.
- Use read-only tokens for analytics when possible.
- Mask tokens in logs.
- Do not store secrets in generated reports.
- Avoid pulling full source code unless required.
