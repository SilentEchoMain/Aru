param(
    [switch]$Json
)

$ErrorActionPreference = "Stop"

$root = Split-Path -Parent $PSScriptRoot
$challengePath = Join-Path $root "COMMUNITY_CHALLENGES.tsv"

if (!(Test-Path $challengePath)) {
    Write-Error "COMMUNITY_CHALLENGES.tsv is missing."
    exit 1
}

$rows = @(Import-Csv -Delimiter "`t" $challengePath)

function Count-By($property) {
    return @($rows | Group-Object $property | Sort-Object Name | ForEach-Object {
        [pscustomobject]@{
            name = $_.Name
            count = $_.Count
        }
    })
}

$report = [pscustomobject]@{
    challenges = $rows.Count
    tracks = Count-By "track"
    levels = Count-By "level"
    statuses = Count-By "status"
    sample = @($rows | Select-Object -First 6 id, track, level, title, seed_aru)
}

if ($Json) {
    $report | ConvertTo-Json -Depth 8
} else {
    Write-Output "Aru Adoption Report"
    Write-Output "Community challenges: $($report.challenges)"
    Write-Output ""
    Write-Output "Tracks:"
    $report.tracks | Format-Table -AutoSize
    Write-Output "Levels:"
    $report.levels | Format-Table -AutoSize
    Write-Output "Statuses:"
    $report.statuses | Format-Table -AutoSize
    Write-Output "Sample:"
    $report.sample | Format-Table -AutoSize
}
