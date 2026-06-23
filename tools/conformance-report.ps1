param(
    [switch]$Json
)

$ErrorActionPreference = "Stop"

$root = Split-Path -Parent $PSScriptRoot
$suitePath = Join-Path $root "CONFORMANCE.tsv"

if (!(Test-Path $suitePath)) {
    Write-Error "CONFORMANCE.tsv is missing."
    exit 1
}

$rows = @(Import-Csv -Delimiter "`t" $suitePath)

function Count-By($property) {
    return @($rows | Group-Object $property | Sort-Object Name | ForEach-Object {
        [pscustomobject]@{
            name = $_.Name
            count = $_.Count
        }
    })
}

$report = [pscustomobject]@{
    conformanceRows = $rows.Count
    expected = Count-By "expected"
    levels = Count-By "level"
    features = Count-By "feature"
    kinds = Count-By "expected_kind"
    sample = @($rows | Select-Object -First 8 id, expected, level, feature, text, expected_kind)
}

if ($Json) {
    $report | ConvertTo-Json -Depth 8
} else {
    Write-Output "Aru Conformance Report"
    Write-Output "Rows: $($report.conformanceRows)"
    Write-Output ""
    Write-Output "Expected:"
    $report.expected | Format-Table -AutoSize
    Write-Output "Levels:"
    $report.levels | Format-Table -AutoSize
    Write-Output "Features:"
    $report.features | Format-Table -AutoSize
    Write-Output "Kinds:"
    $report.kinds | Format-Table -AutoSize
    Write-Output "Sample:"
    $report.sample | Format-Table -AutoSize
}
