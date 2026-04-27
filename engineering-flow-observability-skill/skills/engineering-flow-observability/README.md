# Engineering Flow Observability Copilot Skill

This skill helps engineering teams understand where time is spent from **Jira story pickup** to **lower-environment deployment**.

It is designed for environments using tools such as:

- GitHub or Bitbucket
- Jira
- Jenkins or Jenkins-like CI/CD
- SonarQube
- Spinnaker
- Confluence
- GitHub Copilot / Copilot custom agent workflows

## Primary Goal

Measure engineering delivery flow without blaming engineers.

This skill focuses on:

- Code commit timing
- Pull request lifecycle
- CI build queue and execution time
- Sonar quality gate delay
- Review and approval delay
- Merge delay
- Spinnaker deployment delay
- Lower-environment deployment completion

## Recommended Folder Structure

```text
skills/
  engineering-flow-observability/
    README.md
    skill.yaml
    knowledge/
      01-flow-analysis-overview.md
      02-data-sources-and-authentication.md
      03-event-correlation-model.md
      04-timeline-metrics.md
      05-bottleneck-classification.md
      06-reporting-and-retro-insights.md
      07-implementation-roadmap.md
    prompts/
      01-story-flow-analysis.md
      02-pr-wait-analysis.md
      03-ci-cd-bottleneck-analysis.md
      04-sprint-retro-summary.md
      05-confluence-report-generation.md
      06-leadership-summary.md
    scripts/
      Invoke-FlowAnalysis.ps1
      Get-JiraStory.ps1
      Get-GitPullRequestTimeline.ps1
      Get-JenkinsBuildTimeline.ps1
      Get-SonarQualityGate.ps1
      Get-SpinnakerDeploymentTimeline.ps1
      New-FlowReport.ps1
      Publish-ConfluenceReport.ps1
```

## How to Use

### 1. Configure environment variables

Set the required tokens before running scripts.

```powershell
$env:JIRA_BASE_URL="https://jira.example.com"
$env:JIRA_TOKEN="replace-with-token"
$env:GITHUB_BASE_URL="https://api.github.com"
$env:GITHUB_TOKEN="replace-with-token"
$env:JENKINS_BASE_URL="https://jenkins.example.com"
$env:JENKINS_TOKEN="replace-with-token"
$env:SONAR_BASE_URL="https://sonarqube.example.com"
$env:SONAR_TOKEN="replace-with-token"
$env:SPINNAKER_BASE_URL="https://spinnaker.example.com"
$env:SPINNAKER_TOKEN="replace-with-token"
$env:CONFLUENCE_BASE_URL="https://confluence.example.com"
$env:CONFLUENCE_TOKEN="replace-with-token"
```

### 2. Run a story flow analysis

```powershell
./scripts/Invoke-FlowAnalysis.ps1 `
  -JiraStoryId "PAY-1234" `
  -Repository "payment-service" `
  -PullRequestId "812" `
  -BuildId "payment-service-main-456" `
  -SpinnakerPipelineId "01HXYZ" `
  -OutputPath "./flow-report-PAY-1234.md"
```

### 3. Ask Copilot to summarize the output

Use prompts from the `prompts/` folder to generate:

- Engineer-friendly summary
- Sprint retro summary
- Leadership summary
- Confluence-ready report

## Positioning

Use this skill as **Engineering Flow Observability**, not as developer surveillance.

Recommended framing:

> We are measuring system friction, not individual effort.

