param(
  [Parameter(Mandatory=$true)][string]$ReportPath,
  [Parameter(Mandatory=$true)][string]$SpaceKey,
  [Parameter(Mandatory=$true)][string]$PageTitle
)

function Get-RequiredEnv($Name) {
  $Value = [Environment]::GetEnvironmentVariable($Name)
  if ([string]::IsNullOrWhiteSpace($Value)) { throw "Missing required environment variable: $Name" }
  return $Value
}

$BaseUrl = Get-RequiredEnv "CONFLUENCE_BASE_URL"
$Token = Get-RequiredEnv "CONFLUENCE_TOKEN"
$Headers = @{ Authorization = "Bearer $Token"; Accept = "application/json"; "Content-Type" = "application/json" }
$Report = Get-Content -Path $ReportPath -Raw

$Body = @{
  type = "page"
  title = $PageTitle
  space = @{ key = $SpaceKey }
  body = @{
    storage = @{
      value = "<pre>$([System.Web.HttpUtility]::HtmlEncode($Report))</pre>"
      representation = "storage"
    }
  }
} | ConvertTo-Json -Depth 10

$Url = "$BaseUrl/rest/api/content"

# Pseudo-real call. Uncomment in real environment.
# $Response = Invoke-RestMethod -Method Post -Uri $Url -Headers $Headers -Body $Body

$Response = [PSCustomObject]@{
  status = "SIMULATED"
  message = "Would publish report to Confluence space $SpaceKey with title '$PageTitle'."
  url = $Url
}

return $Response
