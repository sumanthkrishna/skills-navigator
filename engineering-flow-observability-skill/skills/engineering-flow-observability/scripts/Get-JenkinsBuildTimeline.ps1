param(
  [Parameter(Mandatory=$true)][string]$BuildId
)

function Get-RequiredEnv($Name) {
  $Value = [Environment]::GetEnvironmentVariable($Name)
  if ([string]::IsNullOrWhiteSpace($Value)) { throw "Missing required environment variable: $Name" }
  return $Value
}

$BaseUrl = Get-RequiredEnv "JENKINS_BASE_URL"
$Token = Get-RequiredEnv "JENKINS_TOKEN"
$Headers = @{ Authorization = "Bearer $Token"; Accept = "application/json" }
$Url = "$BaseUrl/job/$BuildId/api/json"

# Pseudo-real call. Uncomment in real environment.
# $Build = Invoke-RestMethod -Method Get -Uri $Url -Headers $Headers

$Timeline = @(
  [PSCustomObject]@{ event_type="CI_QUEUED"; timestamp_utc="2026-04-27T18:05:00Z"; source_system="Jenkins"; metadata=@{ build_id=$BuildId } },
  [PSCustomObject]@{ event_type="CI_STARTED"; timestamp_utc="2026-04-27T18:22:00Z"; source_system="Jenkins"; metadata=@{ build_id=$BuildId } },
  [PSCustomObject]@{ event_type="CI_FAILED"; timestamp_utc="2026-04-27T18:55:00Z"; source_system="Jenkins"; metadata=@{ reason="unit-test-failure" } },
  [PSCustomObject]@{ event_type="CI_STARTED"; timestamp_utc="2026-04-27T20:10:00Z"; source_system="Jenkins"; metadata=@{ build_id="$BuildId-rerun" } },
  [PSCustomObject]@{ event_type="CI_PASSED"; timestamp_utc="2026-04-27T20:49:00Z"; source_system="Jenkins"; metadata=@{ build_id="$BuildId-rerun" } }
)

return $Timeline
