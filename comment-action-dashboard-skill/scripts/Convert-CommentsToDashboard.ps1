param(
    [Parameter(Mandatory=$true)][string]$InputJson,
    [string]$OutputJson = "./output/action-dashboard.json"
)

$data = Get-Content $InputJson -Raw | ConvertFrom-Json
$rows = @()

foreach ($item in $data.items) {
    $text = $item.latest_comment
    $priority = "P3"
    $status = "Track"
    $action = "Review comment and determine next step."

    if ($text -match "blocked|waiting|failed|failing|urgent|unclear") {
        $priority = "P1"
        $status = "Blocked/At Risk"
        $action = "Assign owner and remove blocker today."
    } elseif ($text -match "review|approve|merge") {
        $priority = "P2"
        $status = "Needs Review"
        $action = "Assign reviewer and set review deadline."
    }

    $rows += [pscustomobject]@{
        Priority = $priority
        Source = $item.source
        Item = $item.item
        LatestSignal = $text
        ActionRequired = $action
        Owner = $item.owner
        Due = "Today/Tomorrow"
        Status = $status
        Confidence = "Medium"
    }
}

$rows | ConvertTo-Json -Depth 8 | Set-Content $OutputJson
Write-Host "Converted comments to dashboard: $OutputJson"
