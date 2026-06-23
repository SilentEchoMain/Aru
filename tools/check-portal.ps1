$ErrorActionPreference = "Stop"

$root = Split-Path -Parent $PSScriptRoot
$indexPath = Join-Path $root "index.html"
$releasesPath = Join-Path $root "RELEASES.tsv"

function Fail($message) {
    Write-Error $message
    exit 1
}

if (!(Test-Path $indexPath)) {
    Fail "index.html is missing."
}
if (!(Test-Path $releasesPath)) {
    Fail "RELEASES.tsv is missing."
}

$html = Get-Content $indexPath -Raw
foreach ($required in @(
    "Project Dashboard",
    "Portal Filters",
    "Release Timeline",
    "GOVERNANCE.md",
    "STYLE_GUIDE.md",
    "AUTHORING.md",
    "TEXT_WORKFLOW.md",
    "TEXT_SUBMISSIONS.tsv",
    "Text Submission Queue",
    "submissionSearch",
    "ADOPTION.md",
    "TEACHER_GUIDE.md",
    "WORKSHOP_PLAN.md",
    "COMMUNITY_CHALLENGES.tsv",
    "Community Challenges",
    "challengeSearch",
    "BENCHMARK.md",
    "QUALITY_METRICS.md",
    "TRANSLATION_BENCH.tsv",
    "Translation Benchmark",
    "benchmarkSearch",
    "REVIEW_CHECKLIST.md",
    "CODE_OF_CONDUCT.md",
    "editor/vscode/aru.tmLanguage.json",
    "RELEASES.tsv",
    "lexiconDomain",
    "lexiconLevel",
    "corpusLevel",
    "corpusTopic",
    "dialogueLevel",
    "dialogueTopic",
    "statsGrid",
    "releaseTable"
)) {
    if ($html -notmatch [regex]::Escape($required)) {
        Fail "Portal is missing required content: $required"
    }
}

$releases = @(Import-Csv -Delimiter "`t" $releasesPath)
if ($releases.Count -lt 14) {
    Fail "Expected at least 14 releases, got $($releases.Count)."
}

$columns = @($releases[0].PSObject.Properties.Name)
foreach ($column in @("version", "channel", "status", "core", "focus", "artifacts")) {
    if ($columns -notcontains $column) {
        Fail "RELEASES.tsv is missing required column: $column"
    }
}

$current = @($releases | Where-Object { $_.status -eq "current" })
if ($current.Count -ne 1) {
    Fail "Expected exactly one current release, got $($current.Count)."
}
if ($current[0].version -ne "v1.13.0") {
    Fail "Expected current release v1.13.0, got $($current[0].version)."
}
if (($releases | Where-Object { $_.core -ne "v1.0.0" }).Count -gt 0) {
    Fail "Every project release should preserve language core v1.0.0."
}

Write-Output "Portal check passed."
Write-Output "Releases: $($releases.Count)"
Write-Output "Current release: $($current[0].version)"
