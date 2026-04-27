param(
  [Parameter(Mandatory=$true)][string]$Repository,
  [Parameter(Mandatory=$true)][string]$PullRequestId,
  [ValidateSet("GitHub","Bitbucket")][string]$Provider="GitHub"
)

function Get-RequiredEnv($Name) {
  $Value = [Environment]::GetEnvironmentVariable($Name)
  if ([string]::IsNullOrWhiteSpace($Value)) { throw "Missing required environment variable: $Name" }
  return $Value
}

if ($Provider -eq "GitHub") {
  $BaseUrl = Get-RequiredEnv "GITHUB_BASE_URL"
  $Token = Get-RequiredEnv "GITHUB_TOKEN"
  $Headers = @{ Authorization = "Bearer $Token"; Accept = "application/vnd.github+json" }
  $Url = "$BaseUrl/repos/$Repository/pulls/$PullRequestId"
} else {
  $BaseUrl = Get-RequiredEnv "BITBUCKET_BASE_URL"
  $Token = Get-RequiredEnv "BITBUCKET_TOKEN"
  $Headers = @{ Authorization = "Bearer $Token"; Accept = "application/json" }
  $Url = "$BaseUrl/repositories/$Repository/pullrequests/$PullRequestId"
}

# Pseudo-real call. Uncomment in real environment.
# $Pr = Invoke-RestMethod -Method Get -Uri $Url -Headers $Headers

$Timeline = @(
  [PSCustomObject]@{ event_type="FIRST_COMMIT"; timestamp_utc="2026-04-27T13:00:00Z"; source_system=$Provider; metadata=@{ commit_sha="abc123" } },
  [PSCustomObject]@{ event_type="PR_CREATED"; timestamp_utc="2026-04-27T18:00:00Z"; source_system=$Provider; metadata=@{ pull_request_id=$PullRequestId } },
  [PSCustomObject]@{ event_type="FIRST_REVIEW"; timestamp_utc="2026-04-28T13:00:00Z"; source_system=$Provider },
  [PSCustomObject]@{ event_type="PR_APPROVED"; timestamp_utc="2026-04-28T15:00:00Z"; source_system=$Provider },
  [PSCustomObject]@{ event_type="PR_MERGED"; timestamp_utc="2026-04-28T16:00:00Z"; source_system=$Provider }
)

return $Timeline
