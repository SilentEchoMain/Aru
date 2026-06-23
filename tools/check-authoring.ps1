$ErrorActionPreference = "Stop"

$root = Split-Path -Parent $PSScriptRoot
$queuePath = Join-Path $root "TEXT_SUBMISSIONS.tsv"

function Fail($message) {
    Write-Error $message
    exit 1
}

function Get-AruTokens($value) {
    return @(($value -replace '[\.,\?!:;\(\)\[\]\{\}"'']', ' ') -split '\s+' | Where-Object { $_ })
}

if (!(Test-Path $queuePath)) {
    Fail "TEXT_SUBMISSIONS.tsv is missing."
}

foreach ($file in @("TEXT_WORKFLOW.md", "AUTHORING.md", "tools/new-text-submission.ps1")) {
    if (!(Test-Path (Join-Path $root $file))) {
        Fail "Required authoring file is missing: $file"
    }
}

$rows = @(Import-Csv -Delimiter "`t" $queuePath)
if ($rows.Count -lt 12) {
    Fail "Expected at least 12 text submissions, got $($rows.Count)."
}

$columns = @($rows[0].PSObject.Properties.Name)
foreach ($column in @("id", "type", "level", "topic", "aru", "en", "notes", "status")) {
    if ($columns -notcontains $column) {
        Fail "TEXT_SUBMISSIONS.tsv is missing required column: $column"
    }
}

$allowedTypes = @("phrase", "corpus", "dialogue", "prompt")
$allowedLevels = @("A0", "A1", "A2", "B1")
$allowedStatuses = @("draft", "review", "accepted", "rejected")

$lexicon = @(Import-Csv -Delimiter "`t" (Join-Path $root "LEXICON.tsv"))
$roots = @{}
foreach ($row in $lexicon) {
    $roots[$row.root] = $true
}

$ids = $rows.id | Group-Object | Where-Object { $_.Count -gt 1 }
if ($ids) {
    Fail ("Duplicate text submission IDs: " + (($ids | ForEach-Object { $_.Name }) -join ", "))
}

$unknownTokens = @()
foreach ($row in $rows) {
    if ($row.id -notmatch '^S\d{3}$') {
        Fail "Invalid text submission ID: $($row.id)"
    }
    if ($allowedTypes -notcontains $row.type) {
        Fail "Unsupported text submission type for $($row.id): $($row.type)"
    }
    if ($allowedLevels -notcontains $row.level) {
        Fail "Unsupported text submission level for $($row.id): $($row.level)"
    }
    if ($row.topic -notmatch '^[a-z0-9-]+$') {
        Fail "Invalid topic for $($row.id): $($row.topic)"
    }
    if ($allowedStatuses -notcontains $row.status) {
        Fail "Unsupported text submission status for $($row.id): $($row.status)"
    }
    if ([string]::IsNullOrWhiteSpace($row.aru) -or [string]::IsNullOrWhiteSpace($row.en)) {
        Fail "Missing Aru or English text for $($row.id)."
    }

    $skipName = $false
    $skipNumber = $false
    foreach ($token in Get-AruTokens $row.aru) {
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
    Fail ("Unknown text submission tokens: " + (($unknownTokens | Sort-Object -Unique) -join ", "))
}

$statusCounts = @($rows | Group-Object status | Sort-Object Name)
$typeCounts = @($rows | Group-Object type | Sort-Object Name)

Write-Output "Authoring check passed."
Write-Output "Text submissions: $($rows.Count)"
Write-Output "Types:"
$typeCounts | Format-Table Name, Count -AutoSize
Write-Output "Statuses:"
$statusCounts | Format-Table Name, Count -AutoSize
