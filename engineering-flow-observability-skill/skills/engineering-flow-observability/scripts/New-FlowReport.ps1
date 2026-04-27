param(
  [Parameter(Mandatory=$true)][array]$Events,
  [Parameter(Mandatory=$true)][string]$JiraStoryId,
  [Parameter(Mandatory=$true)][string]$OutputPath
)

function Get-EventTime($Events, $Type) {
  $Event = $Events | Where-Object { $_.event_type -eq $Type } | Sort-Object timestamp_utc | Select-Object -First 1
  if ($null -eq $Event) { return $null }
  return [datetime]$Event.timestamp_utc
}

function Get-MinutesBetween($Start, $End) {
  if ($null -eq $Start -or $null -eq $End) { return $null }
  return [math]::Round((New-TimeSpan -Start $Start -End $End).TotalMinutes, 2)
}

$firstCommit = Get-EventTime $Events "FIRST_COMMIT"
$prCreated = Get-EventTime $Events "PR_CREATED"
$firstReview = Get-EventTime $Events "FIRST_REVIEW"
$prApproved = Get-EventTime $Events "PR_APPROVED"
$prMerged = Get-EventTime $Events "PR_MERGED"
$ciQueued = Get-EventTime $Events "CI_QUEUED"
$ciStarted = Get-EventTime $Events "CI_STARTED"
$ciPassed = Get-EventTime $Events "CI_PASSED"
$sonarStarted = Get-EventTime $Events "SONAR_STARTED"
$sonarPassed = Get-EventTime $Events "SONAR_PASSED"
$deployQueued = Get-EventTime $Events "DEPLOYMENT_QUEUED"
$deployStarted = Get-EventTime $Events "DEPLOYMENT_STARTED"
$deploySucceeded = Get-EventTime $Events "DEPLOYMENT_SUCCEEDED"
$lowerValidated = Get-EventTime $Events "LOWER_ENV_VALIDATED"

$Metrics = @(
  [PSCustomObject]@{ Metric="Coding elapsed time"; Minutes=Get-MinutesBetween $firstCommit $prCreated },
  [PSCustomObject]@{ Metric="PR first review wait"; Minutes=Get-MinutesBetween $prCreated $firstReview },
  [PSCustomObject]@{ Metric="PR approval wait"; Minutes=Get-MinutesBetween $prCreated $prApproved },
  [PSCustomObject]@{ Metric="CI queue wait"; Minutes=Get-MinutesBetween $ciQueued $ciStarted },
  [PSCustomObject]@{ Metric="CI pass elapsed"; Minutes=Get-MinutesBetween $ciStarted $ciPassed },
  [PSCustomObject]@{ Metric="Sonar gate duration"; Minutes=Get-MinutesBetween $sonarStarted $sonarPassed },
  [PSCustomObject]@{ Metric="Merge delay after approval"; Minutes=Get-MinutesBetween $prApproved $prMerged },
  [PSCustomObject]@{ Metric="Deployment wait after merge"; Minutes=Get-MinutesBetween $prMerged $deployStarted },
  [PSCustomObject]@{ Metric="Deployment execution duration"; Minutes=Get-MinutesBetween $deployStarted $deploySucceeded },
  [PSCustomObject]@{ Metric="Commit to lower-env validation"; Minutes=Get-MinutesBetween $firstCommit $lowerValidated }
)

$TimelineRows = $Events | Sort-Object timestamp_utc | ForEach-Object {
  "| $($_.timestamp_utc) | $($_.event_type) | $($_.source_system) |"
}

$MetricRows = $Metrics | ForEach-Object {
  $value = if ($null -eq $_.Minutes) { "N/A" } else { "$($_.Minutes)" }
  "| $($_.Metric) | $value |"
}

$Report = @"
# Engineering Flow Report — $JiraStoryId

## Summary

This report analyzes the delivery flow from first commit through lower-environment validation. Use this report to identify system friction, wait states, quality-gate rework, and deployment delay.

## Timeline

| Timestamp UTC | Event | Source |
|---|---|---|
$($TimelineRows -join "`n")

## Metrics

| Metric | Minutes |
|---|---:|
$($MetricRows -join "`n")

## Bottleneck Notes

- Review wait, CI failure/retry, and deployment queue should be inspected first if their values are high.
- This report approximates active engineering time using first commit to PR creation.
- Use this report for process improvement, not individual ranking.

## Recommended Next Actions

1. Review long PR wait periods and improve reviewer assignment.
2. Investigate repeated CI failures and flaky tests.
3. Move Sonar feedback earlier in the developer workflow.
4. Track Spinnaker queue time separately from deployment execution time.
5. Aggregate reports across the sprint for team-level retro insights.
"@

Set-Content -Path $OutputPath -Value $Report -Encoding UTF8
return $OutputPath
