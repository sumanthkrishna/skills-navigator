# 02 – Data Sources and API Flow

The skill is designed around Jira + Bitbucket but can be extended to Jenkins, Spinnaker, Confluence, and observability platforms.

## Primary Inputs

### Jira
Pull these fields:

- Issue key
- Summary
- Status
- Assignee
- Reporter
- Sprint
- Labels
- Priority
- Updated date
- Latest comments
- Acceptance criteria
- Linked issues
- Development links, if available

Pseudo API flow:

```text
Jira JQL -> Issues -> Comments -> Latest comment -> Action extraction -> Dashboard row
```

### Bitbucket
Pull these fields:

- Repository
- Pull request ID
- PR title
- Author
- Reviewers
- State
- Latest activity
- Comments
- Inline comments
- Commit references
- Build status, if available

Pseudo API flow:

```text
Workspace -> Repositories -> Pull Requests -> Comments -> Thread status -> Action extraction -> Dashboard row
```

## Optional Inputs

### Jenkins / CI

- Job name
- Build number
- Status
- Failed stage
- Log summary
- Commit SHA

### Spinnaker / Deployment

- Application
- Pipeline
- Environment
- Deployment status
- Rollback indicator
- Manual judgment waiting

### Confluence

- Linked design pages
- Decision records
- API contracts
- Requirement docs

## Correlation Logic

Correlate items using:

- Jira key in branch name
- Jira key in PR title
- Jira key in commit message
- Jira development panel links
- PR URL pasted in Jira comments
- Deployment commit SHA matching PR commit SHA

## Security Notes

- Never print tokens.
- Use environment variables or secret manager.
- Store only normalized summaries in generated output.
- Avoid exporting sensitive customer data from comments.
