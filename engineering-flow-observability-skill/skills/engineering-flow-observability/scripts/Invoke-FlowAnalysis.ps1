param(
  [Parameter(Mandatory=$true)][string]$JiraStoryId,
  [Parameter(Mandatory=$true)][string]$Repository,
  [Parameter(Mandatory=$true)][string]$PullRequestId,
  [Parameter(Mandatory=$true)][string]$BuildId,
  [Parameter(Mandatory=$true)][string]$SpinnakerPipelineId,
  [string]$ProjectKey=$Repository,
  [string]$BranchName="main",
  [ValidateSet("GitHub","Bitbucket")][string]$GitProvider="GitHub",
  [string]$OutputPath="./flow-report.md"
)

$ScriptRoot = Split-Path -Parent $MyInvocation.MyCommand.Path

. "$ScriptRoot/Get-JiraStory.ps1" -JiraStoryId $JiraStoryId | Out-Null
$GitEvents = & "$ScriptRoot/Get-GitPullRequestTimeline.ps1" -Repository $Repository -PullRequestId $PullRequestId -Provider $GitProvider
$JenkinsEvents = & "$ScriptRoot/Get-JenkinsBuildTimeline.ps1" -BuildId $BuildId
$SonarEvents = & "$ScriptRoot/Get-SonarQualityGate.ps1" -ProjectKey $ProjectKey -BranchName $BranchName
$SpinnakerEvents = & "$ScriptRoot/Get-SpinnakerDeploymentTimeline.ps1" -PipelineId $SpinnakerPipelineId -Environment "lower"

$JiraEvent = [PSCustomObject]@{ event_type="JIRA_IN_PROGRESS"; timestamp_utc="2026-04-27T12:00:00Z"; source_system="Jira"; metadata=@{ story_id=$JiraStoryId } }
$AllEvents = @($JiraEvent) + $GitEvents + $JenkinsEvents + $SonarEvents + $SpinnakerEvents

$ReportPath = & "$ScriptRoot/New-FlowReport.ps1" -Events $AllEvents -JiraStoryId $JiraStoryId -OutputPath $OutputPath
Write-Output "Generated report: $ReportPath"
