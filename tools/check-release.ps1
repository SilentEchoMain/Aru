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
    "CORPUS.tsv",
    "DIALOGUES.tsv",
    "COURSE.md",
    "REFERENCE.md",
    "FLASHCARDS.tsv",
    "PROMPTS.md",
    "EXAMPLES.md",
    "index.html",
    "CHANGELOG.md",
    "CONTRIBUTING.md",
    "tools/build-corpus.ps1",
    "tools/build-learning.ps1",
    "tools/aru-tool.ps1",
    "tools/project-report.ps1",
    "tools/test-site.ps1",
    ".github/ISSUE_TEMPLATE/word-proposal.yml",
    ".github/ISSUE_TEMPLATE/grammar-rfc.yml",
    ".github/ISSUE_TEMPLATE/text-contribution.yml",
    ".github/ISSUE_TEMPLATE/bug-report.yml",
    ".github/PULL_REQUEST_TEMPLATE.md",
    ".github/DISCUSSION_TEMPLATE/writing-challenge.md"
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

$readmeContent = Get-Content (Join-Path $root "README.md") -Raw
$changelogContent = Get-Content (Join-Path $root "CHANGELOG.md") -Raw
if ($readmeContent -notmatch "v1\.3\.0") {
    Fail "Expected README.md to mention project release v1.3.0."
}
if ($changelogContent -notmatch "v1\.3\.0") {
    Fail "Expected CHANGELOG.md to mention project release v1.3.0."
}

$licenseContent = Get-Content (Join-Path $root "LICENSE.md") -Raw
if ($licenseContent -notmatch "Aru License 1\.0") {
    Fail "Expected LICENSE.md to contain Aru License 1.0."
}

$siteContent = Get-Content (Join-Path $root "index.html") -Raw
if ($siteContent -notmatch "Aru Playground") {
    Fail "Expected index.html to contain the Aru Playground."
}
if ($siteContent -notmatch "Learning System") {
    Fail "Expected index.html to contain the learning system."
}
if ($siteContent -notmatch "FLASHCARDS\.tsv") {
    Fail "Expected index.html to reference FLASHCARDS.tsv."
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
if ($phrasebookEntries -lt 150) {
    Fail "Expected at least 150 phrasebook entries, got $phrasebookEntries."
}

$phrasebookRows = Import-Csv -Delimiter "`t" (Join-Path $root "PHRASEBOOK.tsv")
$phrasebookColumns = @($phrasebookRows[0].PSObject.Properties.Name)
foreach ($column in @("id", "topic", "aru", "en")) {
    if ($phrasebookColumns -notcontains $column) {
        Fail "Phrasebook is missing required column: $column"
    }
}

$corpusLines = Get-Content (Join-Path $root "CORPUS.tsv")
$corpusEntries = [Math]::Max(0, $corpusLines.Count - 1)
if ($corpusEntries -lt 100) {
    Fail "Expected at least 100 corpus texts, got $corpusEntries."
}

$corpusRows = Import-Csv -Delimiter "`t" (Join-Path $root "CORPUS.tsv")
$corpusColumns = @($corpusRows[0].PSObject.Properties.Name)
foreach ($column in @("id", "topic", "aru", "en", "notes")) {
    if ($corpusColumns -notcontains $column) {
        Fail "Corpus is missing required column: $column"
    }
}

$dialogueLines = Get-Content (Join-Path $root "DIALOGUES.tsv")
$dialogueEntries = [Math]::Max(0, $dialogueLines.Count - 1)
if ($dialogueEntries -lt 30) {
    Fail "Expected at least 30 dialogues, got $dialogueEntries."
}

$dialogueRows = Import-Csv -Delimiter "`t" (Join-Path $root "DIALOGUES.tsv")
$dialogueColumns = @($dialogueRows[0].PSObject.Properties.Name)
foreach ($column in @("id", "topic", "aru", "en", "notes")) {
    if ($dialogueColumns -notcontains $column) {
        Fail "Dialogues are missing required column: $column"
    }
}

$promptContent = Get-Content (Join-Path $root "PROMPTS.md") -Raw
$promptEntries = ([regex]::Matches($promptContent, "(?m)^## Prompt \d+")).Count
if ($promptEntries -lt 20) {
    Fail "Expected at least 20 writing prompts, got $promptEntries."
}

$courseContent = Get-Content (Join-Path $root "COURSE.md") -Raw
$courseLessons = ([regex]::Matches($courseContent, "(?m)^## Lesson \d+")).Count
if ($courseLessons -lt 12) {
    Fail "Expected at least 12 course lessons, got $courseLessons."
}
if ($courseContent -notmatch "Aru v1\.0\.0") {
    Fail "Expected COURSE.md to identify Aru v1.0.0."
}

$referenceContent = Get-Content (Join-Path $root "REFERENCE.md") -Raw
if ($referenceContent -notmatch "Aru Reference") {
    Fail "Expected REFERENCE.md to contain Aru Reference."
}
if ($referenceContent -notmatch "Aru v1\.0\.0") {
    Fail "Expected REFERENCE.md to identify Aru v1.0.0."
}

$flashcardLines = Get-Content (Join-Path $root "FLASHCARDS.tsv")
$flashcardEntries = [Math]::Max(0, $flashcardLines.Count - 1)
if ($flashcardEntries -lt 300) {
    Fail "Expected at least 300 flashcards, got $flashcardEntries."
}

$flashcardRows = Import-Csv -Delimiter "`t" (Join-Path $root "FLASHCARDS.tsv")
$flashcardColumns = @($flashcardRows[0].PSObject.Properties.Name)
foreach ($column in @("id", "deck", "front", "back", "tags")) {
    if ($flashcardColumns -notcontains $column) {
        Fail "Flashcards are missing required column: $column"
    }
}

$roots = @{}
foreach ($row in $lexiconRows) {
    $roots[$row.root] = $true
}

function Test-AruRows($label, $rows) {
    $unknownTokens = @()
    foreach ($row in $rows) {
        $skipName = $false
        $skipNumber = $false
        $tokens = (($row.aru -replace '[\.,\?:;\(\)\[\]\{\}"'']', ' ') -split '\s+' | Where-Object { $_ })
        foreach ($token in $tokens) {
            if ($skipName) {
                $skipNumber = $false
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
        Fail ("Unknown $label tokens: " + (($unknownTokens | Sort-Object -Unique) -join ", "))
    }
}

Test-AruRows "phrasebook" $phrasebookRows
Test-AruRows "corpus" $corpusRows
Test-AruRows "dialogue" $dialogueRows

Write-Output "Aru release check passed."
Write-Output "Language core: v1.0.0"
Write-Output "Project release: v1.3.0"
Write-Output "Lexicon entries: $lexiconEntries"
Write-Output "Phrasebook entries: $phrasebookEntries"
Write-Output "Corpus texts: $corpusEntries"
Write-Output "Dialogues: $dialogueEntries"
Write-Output "Writing prompts: $promptEntries"
Write-Output "Course lessons: $courseLessons"
Write-Output "Flashcards: $flashcardEntries"
