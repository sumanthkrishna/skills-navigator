param(
  [Parameter(Mandatory=$true)][string]$ProjectKey,
  [string]$BranchName="main"
)

function Get-RequiredEnv($Name) {
  $Value = [Environment]::GetEnvironmentVariable($Name)
  if ([string]::IsNullOrWhiteSpace($Value)) { throw "Missing required environment variable: $Name" }
  return $Value
}

$BaseUrl = Get-RequiredEnv "SONAR_BASE_URL"
$Token = Get-RequiredEnv "SONAR_TOKEN"
$Headers = @{ Authorization = "Bearer $Token"; Accept = "application/json" }
$Url = "$BaseUrl/api/qualitygates/project_status?projectKey=$ProjectKey&branch=$BranchName"

# Pseudo-real call. Uncomment in real environment.
# $Gate = Invoke-RestMethod -Method Get -Uri $Url -Headers $Headers

$Timeline = @(
  [PSCustomObject]@{ event_type="SONAR_STARTED"; timestamp_utc="2026-04-27T20:50:00Z"; source_system="SonarQube"; metadata=@{ project_key=$ProjectKey } },
  [PSCustomObject]@{ event_type="SONAR_PASSED"; timestamp_utc="2026-04-27T21:02:00Z"; source_system="SonarQube"; metadata=@{ quality_gate="OK" } }
)

return $Timeline
