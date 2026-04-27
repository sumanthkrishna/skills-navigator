param(
  [Parameter(Mandatory=$true)][string]$JiraStoryId
)

function Get-RequiredEnv($Name) {
  $Value = [Environment]::GetEnvironmentVariable($Name)
  if ([string]::IsNullOrWhiteSpace($Value)) { throw "Missing required environment variable: $Name" }
  return $Value
}

$BaseUrl = Get-RequiredEnv "JIRA_BASE_URL"
$Token = Get-RequiredEnv "JIRA_TOKEN"

$Headers = @{ Authorization = "Bearer $Token"; Accept = "application/json" }
$Url = "$BaseUrl/rest/api/2/issue/$JiraStoryId?expand=changelog"

# Pseudo-real call. Uncomment in real environment.
# $Response = Invoke-RestMethod -Method Get -Uri $Url -Headers $Headers

$Response = [PSCustomObject]@{
  id = $JiraStoryId
  key = $JiraStoryId
  fields = [PSCustomObject]@{
    summary = "Simulated Jira story summary"
    status = [PSCustomObject]@{ name = "In Progress" }
    sprint = "Sprint 12"
  }
  events = @(
    [PSCustomObject]@{ event_type="JIRA_IN_PROGRESS"; timestamp_utc="2026-04-27T12:00:00Z"; source_system="Jira" }
  )
}

return $Response
