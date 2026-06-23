$ErrorActionPreference = "Stop"

$root = Split-Path -Parent $PSScriptRoot

function Fail($message) {
    Write-Error $message
    exit 1
}

$requiredFiles = @(
    "README.md",
    "LICENSE.md",
    "SPEC.md",
    "LEXICON.tsv",
    "PHRASEBOOK.tsv",
    "EXAMPLES.md",
    "CHANGELOG.md",
    "CONTRIBUTING.md"
)

foreach ($file in $requiredFiles) {
    $path = Join-Path $root $file
    if (!(Test-Path $path)) {
        Fail "Required file is missing: $file"
    }
}

$versionFiles = @("README.md", "SPEC.md", "CHANGELOG.md", "CONTRIBUTING.md")
foreach ($file in $versionFiles) {
    $content = Get-Content (Join-Path $root $file) -Raw
    if ($content -notmatch "v1\.0\.0") {
        Fail "Expected $file to mention v1.0.0."
    }
}

$licenseContent = Get-Content (Join-Path $root "LICENSE.md") -Raw
if ($licenseContent -notmatch "Aru License 1\.0") {
    Fail "Expected LICENSE.md to contain Aru License 1.0."
}

$lexiconLines = Get-Content (Join-Path $root "LEXICON.tsv")
$lexiconEntries = [Math]::Max(0, $lexiconLines.Count - 1)
if ($lexiconEntries -lt 100) {
    Fail "Expected at least 100 lexicon entries, got $lexiconEntries."
}

$lexiconRows = Import-Csv -Delimiter "`t" (Join-Path $root "LEXICON.tsv")
$lexiconColumns = @($lexiconRows[0].PSObject.Properties.Name)
foreach ($column in @("root", "category", "meaning", "notes")) {
    if ($lexiconColumns -notcontains $column) {
        Fail "Lexicon is missing required column: $column"
    }
}
$duplicates = $lexiconRows.root | Group-Object | Where-Object { $_.Count -gt 1 }
if ($duplicates) {
    Fail ("Duplicate roots: " + (($duplicates | ForEach-Object { $_.Name }) -join ", "))
}

$syllablePattern = "^(?:[aeiou]n|[ptkmnslrwy][aeiou]n|[aeiou]|[ptkmnslrwy][aeiou])"
$badRoots = @()
foreach ($row in $lexiconRows) {
    $rest = $row.root
    while ($rest.Length -gt 0) {
        if ($rest -match $syllablePattern) {
            $rest = $rest.Substring($matches[0].Length)
        } else {
            $badRoots += $row.root
            break
        }
    }
}
if ($badRoots.Count -gt 0) {
    Fail ("Roots outside Aru phonology: " + (($badRoots | Sort-Object -Unique) -join ", "))
}

$phrasebookLines = Get-Content (Join-Path $root "PHRASEBOOK.tsv")
$phrasebookEntries = [Math]::Max(0, $phrasebookLines.Count - 1)
if ($phrasebookEntries -lt 100) {
    Fail "Expected at least 100 phrasebook entries, got $phrasebookEntries."
}

$phrasebookRows = Import-Csv -Delimiter "`t" (Join-Path $root "PHRASEBOOK.tsv")
$phrasebookColumns = @($phrasebookRows[0].PSObject.Properties.Name)
foreach ($column in @("id", "topic", "aru", "en")) {
    if ($phrasebookColumns -notcontains $column) {
        Fail "Phrasebook is missing required column: $column"
    }
}

Write-Output "Aru release check passed."
Write-Output "Version: v1.0.0"
Write-Output "Lexicon entries: $lexiconEntries"
Write-Output "Phrasebook entries: $phrasebookEntries"
