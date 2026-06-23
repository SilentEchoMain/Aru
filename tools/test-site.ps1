$ErrorActionPreference = "Stop"

$root = Split-Path -Parent $PSScriptRoot
$indexPath = Join-Path $root "index.html"

function Fail($message) {
    Write-Error $message
    exit 1
}

if (!(Test-Path $indexPath)) {
    Fail "index.html is missing."
}

$html = Get-Content $indexPath -Raw

foreach ($required in @(
    "Aru Playground",
    "Lexicon Search",
    "Phrasebook Search",
    "Corpus Reader",
    "Dialogue Browser",
    "Learning System",
    "LEXICON_POLICY.md",
    "LEXICON.tsv",
    "PHRASEBOOK.tsv",
    "CORPUS.tsv",
    "DIALOGUES.tsv",
    "FLASHCARDS.tsv"
)) {
    if ($html -notmatch [regex]::Escape($required)) {
        Fail "index.html is missing required content: $required"
    }
}

foreach ($file in @("LEXICON.tsv", "LEXICON_POLICY.md", "PHRASEBOOK.tsv", "CORPUS.tsv", "DIALOGUES.tsv", "FLASHCARDS.tsv")) {
    if (!(Test-Path (Join-Path $root $file))) {
        Fail "Site data file is missing: $file"
    }
}

Write-Output "Site smoke test passed."
