param(
    [Parameter(Mandatory=$true)][string]$DashboardJson,
    [string]$OutputFolder = "./output"
)

if (!(Test-Path $OutputFolder)) { New-Item -ItemType Directory -Path $OutputFolder | Out-Null }
$rows = Get-Content $DashboardJson -Raw | ConvertFrom-Json

$rows | Export-Csv -Path (Join-Path $OutputFolder "action-dashboard.csv") -NoTypeInformation

$md = @()
$md += "# Engineering Action Dashboard"
$md += ""
$md += "| Priority | Source | Item | Latest Signal | Action Required | Owner | Due | Status | Confidence |"
$md += "|---|---|---|---|---|---|---|---|---|"
foreach ($row in $rows) {
    $md += "| $($row.Priority) | $($row.Source) | $($row.Item) | $($row.LatestSignal) | $($row.ActionRequired) | $($row.Owner) | $($row.Due) | $($row.Status) | $($row.Confidence) |"
}

$md | Set-Content (Join-Path $OutputFolder "action-dashboard.md")
Write-Host "Export complete."
