param(
    [Parameter(Mandatory=$true)][string]$JiraBaseUrl,
    [Parameter(Mandatory=$true)][string]$JiraJql,
    [Parameter(Mandatory=$true)][string]$BitbucketWorkspace,
    [Parameter(Mandatory=$true)][string]$Repositories,
    [int]$LookbackDays = 14,
    [string]$OutputFolder = "./output"
)

<#
.SYNOPSIS
  Builds an action dashboard from Jira and Bitbucket comments.

.DESCRIPTION
  This script contains pseudo-real API integration patterns. It expects Jira and Bitbucket
  credentials through environment variables and produces normalized comment records.

.REQUIRED ENVIRONMENT VARIABLES
  JIRA_EMAIL
  JIRA_API_TOKEN
  BITBUCKET_USERNAME
  BITBUCKET_APP_PASSWORD
#>

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

if (!(Test-Path $OutputFolder)) { New-Item -ItemType Directory -Path $OutputFolder | Out-Null }

function New-BasicAuthHeader {
    param([string]$User, [string]$Token)
    $pair = "${User}:${Token}"
    $bytes = [System.Text.Encoding]::ASCII.GetBytes($pair)
    $encoded = [Convert]::ToBase64String($bytes)
    return @{ Authorization = "Basic $encoded"; Accept = "application/json" }
}

function Get-JiraIssuesWithComments {
    param([string]$BaseUrl, [string]$Jql)

    $headers = New-BasicAuthHeader -User $env:JIRA_EMAIL -Token $env:JIRA_API_TOKEN
    $body = @{
        jql = $Jql
        maxResults = 50
        fields = @("summary", "status", "assignee", "priority", "comment", "updated", "labels")
    } | ConvertTo-Json -Depth 8

    # Real endpoint:
    # POST $BaseUrl/rest/api/3/search
    # $response = Invoke-RestMethod -Method Post -Uri "$BaseUrl/rest/api/3/search" -Headers $headers -Body $body -ContentType "application/json"

    # Pseudo response for local testing:
    $response = @{
        issues = @(
            @{
                key = "PAY-1421"
                fields = @{
                    summary = "Add retry logic for failed payments"
                    status = @{ name = "In Progress" }
                    priority = @{ name = "High" }
                    assignee = @{ displayName = "Dev Owner" }
                    updated = (Get-Date).ToString("o")
                    comment = @{
                        comments = @(
                            @{ author = @{ displayName = "API Owner" }; created = (Get-Date).AddDays(-1).ToString("o"); body = @{ content = @() }; renderedBody = "Still waiting on final API error response schema." }
                        )
                    }
                }
            }
        )
    }

    return $response.issues
}

function Get-BitbucketPullRequestsWithComments {
    param([string]$Workspace, [string[]]$RepoList)

    $headers = New-BasicAuthHeader -User $env:BITBUCKET_USERNAME -Token $env:BITBUCKET_APP_PASSWORD
    $items = @()

    foreach ($repo in $RepoList) {
        # Real endpoint examples:
        # GET https://api.bitbucket.org/2.0/repositories/$Workspace/$repo/pullrequests?state=OPEN
        # GET https://api.bitbucket.org/2.0/repositories/$Workspace/$repo/pullrequests/{id}/comments

        $items += [pscustomobject]@{
            repository = $repo
            pr_id = 87
            title = "PAY-1421 retry implementation"
            author = "feature-dev"
            state = "OPEN"
            latest_comment = "Build is failing on payment integration test after latest commit."
            updated_on = (Get-Date).ToString("o")
        }
    }

    return $items
}

function Convert-ToDashboardRows {
    param([array]$JiraIssues, [array]$PullRequests)

    $rows = @()

    foreach ($issue in $JiraIssues) {
        $comments = $issue.fields.comment.comments
        $latest = $comments | Sort-Object created | Select-Object -Last 1
        $text = $latest.renderedBody

        $priority = "P2"
        $status = "Needs Review"
        $action = "Review the latest comment and assign the correct owner."

        if ($text -match "waiting|blocked|unclear|schema|contract") {
            $priority = "P1"
            $status = "Blocked"
            $action = "Confirm API contract/schema and update Jira acceptance criteria."
        }

        $rows += [pscustomobject]@{
            Priority = $priority
            Source = "Jira"
            Item = $issue.key
            Title = $issue.fields.summary
            LatestSignal = $text
            ActionRequired = $action
            Owner = $issue.fields.assignee.displayName
            Due = "Today"
            Status = $status
            Confidence = "High"
        }
    }

    foreach ($pr in $PullRequests) {
        $priority = "P2"
        $status = "Needs Review"
        $action = "Review PR comment and resolve reviewer request."

        if ($pr.latest_comment -match "failing|failed|broken|pipeline|build") {
            $priority = "P1"
            $status = "At Risk"
            $action = "Assign PR owner to fix failing integration test and rerun pipeline."
        }

        $rows += [pscustomobject]@{
            Priority = $priority
            Source = "Bitbucket PR"
            Item = "$($pr.repository)#$($pr.pr_id)"
            Title = $pr.title
            LatestSignal = $pr.latest_comment
            ActionRequired = $action
            Owner = $pr.author
            Due = "Today"
            Status = $status
            Confidence = "High"
        }
    }

    return $rows
}

$repoList = $Repositories.Split(",") | ForEach-Object { $_.Trim() } | Where-Object { $_ -ne "" }
$jiraIssues = Get-JiraIssuesWithComments -BaseUrl $JiraBaseUrl -Jql $JiraJql
$prs = Get-BitbucketPullRequestsWithComments -Workspace $BitbucketWorkspace -RepoList $repoList
$rows = Convert-ToDashboardRows -JiraIssues $jiraIssues -PullRequests $prs

$jsonPath = Join-Path $OutputFolder "action-dashboard.json"
$csvPath = Join-Path $OutputFolder "action-dashboard.csv"
$mdPath = Join-Path $OutputFolder "action-dashboard.md"

$rows | ConvertTo-Json -Depth 8 | Set-Content $jsonPath
$rows | Export-Csv -Path $csvPath -NoTypeInformation

$md = @()
$md += "# Engineering Action Dashboard"
$md += ""
$md += "Generated: $(Get-Date -Format o)"
$md += ""
$md += "| Priority | Source | Item | Latest Signal | Action Required | Owner | Due | Status | Confidence |"
$md += "|---|---|---|---|---|---|---|---|---|"
foreach ($row in $rows) {
    $md += "| $($row.Priority) | $($row.Source) | $($row.Item) | $($row.LatestSignal) | $($row.ActionRequired) | $($row.Owner) | $($row.Due) | $($row.Status) | $($row.Confidence) |"
}
$md | Set-Content $mdPath

Write-Host "Dashboard generated:"
Write-Host " - $mdPath"
Write-Host " - $jsonPath"
Write-Host " - $csvPath"
