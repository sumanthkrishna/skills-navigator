param(
  [Parameter(Mandatory=$true)][string]$PipelineId,
  [string]$Environment="lower"
)

function Get-RequiredEnv($Name) {
  $Value = [Environment]::GetEnvironmentVariable($Name)
  if ([string]::IsNullOrWhiteSpace($Value)) { throw "Missing required environment variable: $Name" }
  return $Value
}

$BaseUrl = Get-RequiredEnv "SPINNAKER_BASE_URL"
$Token = Get-RequiredEnv "SPINNAKER_TOKEN"
$Headers = @{ Authorization = "Bearer $Token"; Accept = "application/json" }
$Url = "$BaseUrl/pipelines/$PipelineId"

# Pseudo-real call. Uncomment in real environment.
# $Pipeline = Invoke-RestMethod -Method Get -Uri $Url -Headers $Headers

$Timeline = @(
  [PSCustomObject]@{ event_type="DEPLOYMENT_QUEUED"; timestamp_utc="2026-04-28T16:15:00Z"; source_system="Spinnaker"; metadata=@{ pipeline_id=$PipelineId; environment=$Environment } },
  [PSCustomObject]@{ event_type="DEPLOYMENT_STARTED"; timestamp_utc="2026-04-28T16:50:00Z"; source_system="Spinnaker"; metadata=@{ pipeline_id=$PipelineId; environment=$Environment } },
  [PSCustomObject]@{ event_type="DEPLOYMENT_SUCCEEDED"; timestamp_utc="2026-04-28T17:42:00Z"; source_system="Spinnaker"; metadata=@{ pipeline_id=$PipelineId; environment=$Environment } },
  [PSCustomObject]@{ event_type="LOWER_ENV_VALIDATED"; timestamp_utc="2026-04-28T18:10:00Z"; source_system="Spinnaker"; metadata=@{ validation="smoke-test-passed" } }
)

return $Timeline
