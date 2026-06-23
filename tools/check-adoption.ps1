$ErrorActionPreference = "Stop"

$root = Split-Path -Parent $PSScriptRoot
$challengePath = Join-Path $root "COMMUNITY_CHALLENGES.tsv"

function Fail($message) {
    Write-Error $message
    exit 1
}

function Get-AruTokens($value) {
    return @(($value -replace '[\.,\?!:;\(\)\[\]\{\}"'']', ' ') -split '\s+' | Where-Object { $_ })
}

foreach ($file in @("ADOPTION.md", "TEACHER_GUIDE.md", "WORKSHOP_PLAN.md", "COMMUNITY_CHALLENGES.tsv")) {
    if (!(Test-Path (Join-Path $root $file))) {
        Fail "Required adoption file is missing: $file"
    }
}

$rows = @(Import-Csv -Delimiter "`t" $challengePath)
if ($rows.Count -lt 30) {
    Fail "Expected at least 30 community challenges, got $($rows.Count)."
}

$columns = @($rows[0].PSObject.Properties.Name)
foreach ($column in @("id", "track", "level", "title", "prompt", "seed_aru", "outcome", "check", "status")) {
    if ($columns -notcontains $column) {
        Fail "COMMUNITY_CHALLENGES.tsv is missing required column: $column"
    }
}

$allowedTracks = @("community", "first-contact", "reading", "teaching", "translation", "writing")
$allowedLevels = @("A0", "A1", "A2")
$allowedStatuses = @("draft", "ready", "retired")

$lexicon = @(Import-Csv -Delimiter "`t" (Join-Path $root "LEXICON.tsv"))
$roots = @{}
foreach ($row in $lexicon) {
    $roots[$row.root] = $true
}

$duplicateIds = $rows.id | Group-Object | Where-Object { $_.Count -gt 1 }
if ($duplicateIds) {
    Fail ("Duplicate challenge IDs: " + (($duplicateIds | ForEach-Object { $_.Name }) -join ", "))
}

$unknownTokens = @()
foreach ($row in $rows) {
    if ($row.id -notmatch '^A\d{3}$') {
        Fail "Invalid challenge ID: $($row.id)"
    }
    if ($allowedTracks -notcontains $row.track) {
        Fail "Unsupported challenge track for $($row.id): $($row.track)"
    }
    if ($allowedLevels -notcontains $row.level) {
        Fail "Unsupported challenge level for $($row.id): $($row.level)"
    }
    if ($allowedStatuses -notcontains $row.status) {
        Fail "Unsupported challenge status for $($row.id): $($row.status)"
    }
    foreach ($field in @("title", "prompt", "seed_aru", "outcome", "check")) {
        if ([string]::IsNullOrWhiteSpace($row.$field)) {
            Fail "Challenge $($row.id) has empty field: $field"
        }
    }

    $skipName = $false
    $skipNumber = $false
    foreach ($token in Get-AruTokens $row.seed_aru) {
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
    Fail ("Unknown challenge seed tokens: " + (($unknownTokens | Sort-Object -Unique) -join ", "))
}

$trackCounts = @($rows | Group-Object track | Sort-Object Name)
foreach ($track in $allowedTracks) {
    if (!(($trackCounts | Where-Object { $_.Name -eq $track }))) {
        Fail "Community challenges have no rows for track $track."
    }
}

$levelCounts = @($rows | Group-Object level | Sort-Object Name)
foreach ($level in $allowedLevels) {
    if (!(($levelCounts | Where-Object { $_.Name -eq $level }))) {
        Fail "Community challenges have no rows for level $level."
    }
}

Write-Output "Adoption check passed."
Write-Output "Community challenges: $($rows.Count)"
Write-Output "Tracks:"
$trackCounts | Format-Table Name, Count -AutoSize
Write-Output "Levels:"
$levelCounts | Format-Table Name, Count -AutoSize
