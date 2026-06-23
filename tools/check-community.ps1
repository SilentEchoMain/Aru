$ErrorActionPreference = "Stop"

$root = Split-Path -Parent $PSScriptRoot

function Fail($message) {
    Write-Error $message
    exit 1
}

$requiredFiles = @(
    "CONTRIBUTING.md",
    "GOVERNANCE.md",
    "STYLE_GUIDE.md",
    "REVIEW_CHECKLIST.md",
    "CODE_OF_CONDUCT.md",
    ".github/PULL_REQUEST_TEMPLATE.md",
    ".github/ISSUE_TEMPLATE/config.yml",
    ".github/ISSUE_TEMPLATE/word-proposal.yml",
    ".github/ISSUE_TEMPLATE/grammar-rfc.yml",
    ".github/ISSUE_TEMPLATE/text-contribution.yml",
    ".github/ISSUE_TEMPLATE/bug-report.yml",
    ".github/DISCUSSION_TEMPLATE/writing-challenge.md",
    ".github/DISCUSSION_TEMPLATE/translation-challenge.md"
)

foreach ($file in $requiredFiles) {
    if (!(Test-Path (Join-Path $root $file))) {
        Fail "Required community file is missing: $file"
    }
}

foreach ($file in @("CONTRIBUTING.md", "GOVERNANCE.md", "STYLE_GUIDE.md", "REVIEW_CHECKLIST.md", "CODE_OF_CONDUCT.md")) {
    $content = Get-Content (Join-Path $root $file) -Raw
    if ($content -notmatch "Aru") {
        Fail "$file should identify the Aru project."
    }
}

$governance = Get-Content (Join-Path $root "GOVERNANCE.md") -Raw
foreach ($required in @("Aru v1.0.0", "Decision Flow", "Stability Promise", "compatibility note")) {
    if ($governance -notmatch [regex]::Escape($required)) {
        Fail "GOVERNANCE.md is missing: $required"
    }
}

$style = Get-Content (Join-Path $root "STYLE_GUIDE.md") -Raw
foreach ($required in @("Aru v1.0.0", "A0", "A1", "A2", "check-grammar.ps1")) {
    if ($style -notmatch [regex]::Escape($required)) {
        Fail "STYLE_GUIDE.md is missing: $required"
    }
}

$review = Get-Content (Join-Path $root "REVIEW_CHECKLIST.md") -Raw
foreach ($required in @("check-community.ps1", "check-release.ps1", "LEXICON_POLICY.md", "RELEASES.tsv")) {
    if ($review -notmatch [regex]::Escape($required)) {
        Fail "REVIEW_CHECKLIST.md is missing: $required"
    }
}

$prTemplate = Get-Content (Join-Path $root ".github/PULL_REQUEST_TEMPLATE.md") -Raw
foreach ($required in @("GOVERNANCE.md", "STYLE_GUIDE.md", "REVIEW_CHECKLIST.md", "check-community.ps1")) {
    if ($prTemplate -notmatch [regex]::Escape($required)) {
        Fail "Pull request template is missing: $required"
    }
}

$wordTemplate = Get-Content (Join-Path $root ".github/ISSUE_TEMPLATE/word-proposal.yml") -Raw
foreach ($required in @("Domain", "Learner level", "Alternatives tried")) {
    if ($wordTemplate -notmatch [regex]::Escape($required)) {
        Fail "Word proposal template is missing: $required"
    }
}

Write-Output "Community check passed."
Write-Output "Community files: $($requiredFiles.Count)"
