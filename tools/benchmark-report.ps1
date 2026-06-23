param(
    [switch]$Json
)

$ErrorActionPreference = "Stop"

$root = Split-Path -Parent $PSScriptRoot
$benchPath = Join-Path $root "TRANSLATION_BENCH.tsv"

if (!(Test-Path $benchPath)) {
    Write-Error "TRANSLATION_BENCH.tsv is missing."
    exit 1
}

$rows = @(Import-Csv -Delimiter "`t" $benchPath)

function Count-By($property) {
    return @($rows | Group-Object $property | Sort-Object Name | ForEach-Object {
        [pscustomobject]@{
            name = $_.Name
            count = $_.Count
        }
    })
}

$report = [pscustomobject]@{
    benchmarkRows = $rows.Count
    levels = Count-By "level"
    domains = Count-By "domain"
    phenomena = Count-By "phenomenon"
    sample = @($rows | Select-Object -First 5 id, level, domain, phenomenon, source_en, reference_aru)
}

if ($Json) {
    $report | ConvertTo-Json -Depth 8
} else {
    Write-Output "Aru Translation Benchmark Report"
    Write-Output "Rows: $($report.benchmarkRows)"
    Write-Output ""
    Write-Output "Levels:"
    $report.levels | Format-Table -AutoSize
    Write-Output "Domains:"
    $report.domains | Format-Table -AutoSize
    Write-Output "Phenomena:"
    $report.phenomena | Format-Table -AutoSize
    Write-Output "Sample:"
    $report.sample | Format-Table -AutoSize
}
