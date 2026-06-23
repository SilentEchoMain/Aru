$ErrorActionPreference = "Stop"

$root = Split-Path -Parent $PSScriptRoot
$path = Join-Path $root "LEXICON.tsv"

function Fail($message) {
    Write-Error $message
    exit 1
}

if (!(Test-Path $path)) {
    Fail "LEXICON.tsv is missing."
}

$rows = @(Import-Csv -Delimiter "`t" $path)
if ($rows.Count -lt 100) {
    Fail "Expected at least 100 lexicon rows, got $($rows.Count)."
}

$columns = @($rows[0].PSObject.Properties.Name)
foreach ($column in @("id", "root", "category", "domain", "level", "status", "introduced", "meaning", "notes")) {
    if ($columns -notcontains $column) {
        Fail "LEXICON.tsv is missing required column: $column"
    }
}

$allowedCategories = @(
    "particle",
    "time",
    "relation",
    "conjunction",
    "pronoun",
    "demonstrative",
    "indefinite",
    "quantity",
    "root",
    "quality"
)
$allowedDomains = @("grammar", "society", "world", "body", "action", "quality", "media", "nature", "abstract")
$allowedLevels = @("A0", "A1", "A2", "B1")
$allowedStatuses = @("core", "candidate", "deprecated")
$wordShape = "^(?:[aeiou]n|[ptkmnslrwy][aeiou]n|[aeiou]|[ptkmnslrwy][aeiou])+$"

$duplicateIds = $rows.id | Group-Object | Where-Object { $_.Count -gt 1 }
if ($duplicateIds) {
    Fail ("Duplicate lexicon IDs: " + (($duplicateIds | ForEach-Object { $_.Name }) -join ", "))
}

$duplicateRoots = $rows.root | Group-Object | Where-Object { $_.Count -gt 1 }
if ($duplicateRoots) {
    Fail ("Duplicate roots: " + (($duplicateRoots | ForEach-Object { $_.Name }) -join ", "))
}

$expected = 1
foreach ($row in $rows) {
    $expectedId = "ARU-{0:000}" -f $expected
    if ($row.id -ne $expectedId) {
        Fail "Expected ID $expectedId, got $($row.id) for root $($row.root). Do not leave ID gaps."
    }
    if ($row.root -notmatch $wordShape) {
        Fail "Root outside Aru phonology: $($row.root)"
    }
    if ($allowedCategories -notcontains $row.category) {
        Fail "Unsupported category for $($row.root): $($row.category)"
    }
    if ($allowedDomains -notcontains $row.domain) {
        Fail "Unsupported domain for $($row.root): $($row.domain)"
    }
    if ($allowedLevels -notcontains $row.level) {
        Fail "Unsupported level for $($row.root): $($row.level)"
    }
    if ($allowedStatuses -notcontains $row.status) {
        Fail "Unsupported status for $($row.root): $($row.status)"
    }
    if ($row.introduced -notmatch '^v\d+\.\d+\.\d+$') {
        Fail "Invalid introduced release for $($row.root): $($row.introduced)"
    }
    if ([string]::IsNullOrWhiteSpace($row.meaning)) {
        Fail "Missing meaning for $($row.root)."
    }
    $expected++
}

$statusCounts = @($rows | Group-Object status | Sort-Object Name)
$domainCounts = @($rows | Group-Object domain | Sort-Object Name)
$levelCounts = @($rows | Group-Object level | Sort-Object Name)

Write-Output "Aru lexicon check passed."
Write-Output "Rows: $($rows.Count)"
Write-Output "Statuses:"
$statusCounts | Format-Table Name, Count -AutoSize
Write-Output "Domains:"
$domainCounts | Format-Table Name, Count -AutoSize
Write-Output "Levels:"
$levelCounts | Format-Table Name, Count -AutoSize
