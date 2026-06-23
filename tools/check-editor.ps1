$ErrorActionPreference = "Stop"

$root = Split-Path -Parent $PSScriptRoot

function Fail($message) {
    Write-Error $message
    exit 1
}

$requiredFiles = @(
    "AUTHORING.md",
    "editor/vscode/aru.tmLanguage.json",
    "editor/vscode/aru.code-snippets",
    "editor/vscode/language-configuration.json"
)

foreach ($file in $requiredFiles) {
    if (!(Test-Path (Join-Path $root $file))) {
        Fail "Required editor file is missing: $file"
    }
}

function Read-Json($name) {
    try {
        return Get-Content (Join-Path $root $name) -Raw | ConvertFrom-Json
    } catch {
        Fail "Invalid JSON in ${name}: $($_.Exception.Message)"
    }
}

$grammar = Read-Json "editor/vscode/aru.tmLanguage.json"
if ($grammar.scopeName -ne "source.aru") {
    Fail "TextMate grammar should use scopeName source.aru."
}
if (@($grammar.patterns).Count -lt 8) {
    Fail "TextMate grammar should contain at least 8 patterns."
}

$grammarText = Get-Content (Join-Path $root "editor/vscode/aru.tmLanguage.json") -Raw
foreach ($token in @("ra", "ke", "le", "re", "ri", "ya", "pasu")) {
    if ($grammarText -notmatch "\b$token\b") {
        Fail "TextMate grammar is missing token: $token"
    }
}

$snippets = Read-Json "editor/vscode/aru.code-snippets"
$snippetNames = @($snippets.PSObject.Properties.Name)
foreach ($required in @("Aru basic sentence", "Aru object sentence", "Aru context frame", "Aru content clause", "Aru relative phrase", "Aru corpus row")) {
    if ($snippetNames -notcontains $required) {
        Fail "Snippet file is missing: $required"
    }
}

$languageConfig = Read-Json "editor/vscode/language-configuration.json"
if ($languageConfig.comments.lineComment -ne "#") {
    Fail "Language configuration should define # as the line comment."
}

$authoring = Get-Content (Join-Path $root "AUTHORING.md") -Raw
foreach ($required in @("Aru v1.0.0", "STYLE_GUIDE.md", "REVIEW_CHECKLIST.md", "check-grammar.ps1")) {
    if ($authoring -notmatch [regex]::Escape($required)) {
        Fail "AUTHORING.md is missing: $required"
    }
}

Write-Output "Editor check passed."
Write-Output "Editor files: $($requiredFiles.Count)"
Write-Output "Snippet count: $($snippetNames.Count)"
