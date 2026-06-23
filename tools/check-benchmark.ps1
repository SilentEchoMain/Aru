$ErrorActionPreference = "Stop"

$root = Split-Path -Parent $PSScriptRoot
$benchPath = Join-Path $root "TRANSLATION_BENCH.tsv"

function Fail($message) {
    Write-Error $message
    exit 1
}

function Get-AruTokens($value) {
    return @(($value -replace '[\.,\?!:;\(\)\[\]\{\}"'']', ' ') -split '\s+' | Where-Object { $_ })
}

if (!(Test-Path $benchPath)) {
    Fail "TRANSLATION_BENCH.tsv is missing."
}

foreach ($file in @("BENCHMARK.md", "QUALITY_METRICS.md")) {
    if (!(Test-Path (Join-Path $root $file))) {
        Fail "Required benchmark file is missing: $file"
    }
}

$rows = @(Import-Csv -Delimiter "`t" $benchPath)
if ($rows.Count -lt 50) {
    Fail "Expected at least 50 benchmark rows, got $($rows.Count)."
}

$columns = @($rows[0].PSObject.Properties.Name)
foreach ($column in @("id", "level", "domain", "phenomenon", "source_en", "reference_aru", "notes")) {
    if ($columns -notcontains $column) {
        Fail "TRANSLATION_BENCH.tsv is missing required column: $column"
    }
}

$allowedLevels = @("A0", "A1", "A2")
$allowedPhenomena = @(
    "cause",
    "comparison",
    "content",
    "context",
    "coordination",
    "imperative",
    "modal",
    "name",
    "negation",
    "object",
    "phase",
    "predicate",
    "quantity",
    "question",
    "relation",
    "relative",
    "time"
)

$lexicon = @(Import-Csv -Delimiter "`t" (Join-Path $root "LEXICON.tsv"))
$roots = @{}
foreach ($row in $lexicon) {
    $roots[$row.root] = $true
}

$duplicateIds = $rows.id | Group-Object | Where-Object { $_.Count -gt 1 }
if ($duplicateIds) {
    Fail ("Duplicate benchmark IDs: " + (($duplicateIds | ForEach-Object { $_.Name }) -join ", "))
}

$duplicateSources = $rows.source_en | Group-Object | Where-Object { $_.Count -gt 1 }
if ($duplicateSources) {
    Fail ("Duplicate benchmark source prompts: " + (($duplicateSources | ForEach-Object { $_.Name }) -join " | "))
}

$unknownTokens = @()
foreach ($row in $rows) {
    if ($row.id -notmatch '^B\d{3}$') {
        Fail "Invalid benchmark ID: $($row.id)"
    }
    if ($allowedLevels -notcontains $row.level) {
        Fail "Unsupported benchmark level for $($row.id): $($row.level)"
    }
    if ($row.domain -notmatch '^[a-z0-9-]+$') {
        Fail "Invalid benchmark domain for $($row.id): $($row.domain)"
    }
    if ($allowedPhenomena -notcontains $row.phenomenon) {
        Fail "Unsupported benchmark phenomenon for $($row.id): $($row.phenomenon)"
    }
    if ([string]::IsNullOrWhiteSpace($row.source_en) -or [string]::IsNullOrWhiteSpace($row.reference_aru)) {
        Fail "Missing source or reference text for $($row.id)."
    }

    $skipName = $false
    $skipNumber = $false
    foreach ($token in Get-AruTokens $row.reference_aru) {
        if ($skipName) {
            $skipName = $false
            continue
        }
        if ($skipNumber) {
            if ($token -match '^\d+$') {
                $skipNumber = $false
                continue
            }
            $skipNumber = $false
        }
        if ($token -eq "ya") {
            $skipName = $true
            continue
        }
        if ($token -eq "saka") {
            $skipNumber = $true
            continue
        }
        if ($token -match '^\d+$') {
            continue
        }
        if (!$roots.ContainsKey($token)) {
            $unknownTokens += "$($row.id):$token"
        }
    }
}

if ($unknownTokens.Count -gt 0) {
    Fail ("Unknown benchmark tokens: " + (($unknownTokens | Sort-Object -Unique) -join ", "))
}

$levelCounts = @($rows | Group-Object level | Sort-Object Name)
foreach ($level in $allowedLevels) {
    if (!(($levelCounts | Where-Object { $_.Name -eq $level }))) {
        Fail "Benchmark has no rows for level $level."
    }
}

$phenomenonCounts = @($rows | Group-Object phenomenon | Sort-Object Name)
if ($phenomenonCounts.Count -lt 12) {
    Fail "Expected at least 12 benchmark phenomena, got $($phenomenonCounts.Count)."
}

Write-Output "Benchmark check passed."
Write-Output "Benchmark rows: $($rows.Count)"
Write-Output "Levels:"
$levelCounts | Format-Table Name, Count -AutoSize
Write-Output "Phenomena:"
$phenomenonCounts | Format-Table Name, Count -AutoSize
