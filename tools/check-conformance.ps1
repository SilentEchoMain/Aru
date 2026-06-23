$ErrorActionPreference = "Stop"

$root = Split-Path -Parent $PSScriptRoot
$suitePath = Join-Path $root "CONFORMANCE.tsv"

. (Join-Path $root "tools/parse-aru.ps1")

function Fail($message) {
    Write-Error $message
    exit 1
}

foreach ($file in @("GRAMMAR.md", "CONFORMANCE.tsv", "tools/parse-aru.ps1", "tools/conformance-report.ps1")) {
    if (!(Test-Path (Join-Path $root $file))) {
        Fail "Required conformance file is missing: $file"
    }
}

$rows = @(Import-Csv -Delimiter "`t" $suitePath)
if ($rows.Count -lt 60) {
    Fail "Expected at least 60 conformance rows, got $($rows.Count)."
}

$columns = @($rows[0].PSObject.Properties.Name)
foreach ($column in @("id", "expected", "level", "feature", "text", "expected_kind", "notes")) {
    if ($columns -notcontains $column) {
        Fail "CONFORMANCE.tsv is missing required column: $column"
    }
}

$allowedExpected = @("valid", "invalid")
$allowedLevels = @("A0", "A1", "A2")
$allowedKinds = @("declarative", "imperative", "yesno_question", "unknown_question", "invalid")
$allowedFeatures = @(
    "cause",
    "comparison",
    "content",
    "context",
    "coordination",
    "imperative",
    "invalid",
    "modal",
    "name",
    "negation",
    "object",
    "phase",
    "predicate",
    "quantity",
    "relation",
    "relative",
    "time",
    "unknown",
    "yesno"
)

$duplicateIds = $rows.id | Group-Object | Where-Object { $_.Count -gt 1 }
if ($duplicateIds) {
    Fail ("Duplicate conformance IDs: " + (($duplicateIds | ForEach-Object { $_.Name }) -join ", "))
}

$failures = New-Object System.Collections.Generic.List[object]
foreach ($row in $rows) {
    if ($row.id -notmatch '^C\d{3}$') {
        Fail "Invalid conformance ID: $($row.id)"
    }
    if ($allowedExpected -notcontains $row.expected) {
        Fail "Unsupported expected value for $($row.id): $($row.expected)"
    }
    if ($allowedLevels -notcontains $row.level) {
        Fail "Unsupported conformance level for $($row.id): $($row.level)"
    }
    if ($allowedFeatures -notcontains $row.feature) {
        Fail "Unsupported conformance feature for $($row.id): $($row.feature)"
    }
    if ($allowedKinds -notcontains $row.expected_kind) {
        Fail "Unsupported conformance kind for $($row.id): $($row.expected_kind)"
    }

    $parsed = Parse-AruText $row.text
    $expectedOk = $row.expected -eq "valid"
    if ($parsed.ok -ne $expectedOk) {
        $failures.Add([pscustomobject]@{
            id = $row.id
            expected = $row.expected
            actualOk = $parsed.ok
            text = $row.text
            issues = (($parsed.statements | ForEach-Object { $_.issues }) -join "; ")
        }) | Out-Null
        continue
    }

    if ($expectedOk) {
        $actualKind = $parsed.statements[0].kind
        if ($actualKind -ne $row.expected_kind) {
            $failures.Add([pscustomobject]@{
                id = $row.id
                expected = $row.expected_kind
                actualOk = $parsed.ok
                text = $row.text
                issues = "expected kind $($row.expected_kind), got $actualKind"
            }) | Out-Null
        }
    }
}

if ($failures.Count -gt 0) {
    Write-Output "Conformance check failed."
    $failures | Format-Table -AutoSize
    exit 1
}

$expectedCounts = @($rows | Group-Object expected | Sort-Object Name)
$featureCounts = @($rows | Group-Object feature | Sort-Object Name)
$levelCounts = @($rows | Group-Object level | Sort-Object Name)

Write-Output "Conformance check passed."
Write-Output "Conformance rows: $($rows.Count)"
Write-Output "Expected:"
$expectedCounts | Format-Table Name, Count -AutoSize
Write-Output "Levels:"
$levelCounts | Format-Table Name, Count -AutoSize
Write-Output "Features:"
$featureCounts | Format-Table Name, Count -AutoSize
