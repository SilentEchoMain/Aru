$ErrorActionPreference = "Stop"

$root = Split-Path -Parent $PSScriptRoot

function Clean($value) {
    return (($value -replace "`t", " ") -replace "\r?\n", " ").Trim()
}

$releases = @(
    [pscustomobject]@{
        version = "v1.9.0"
        channel = "project"
        status = "current"
        core = "v1.0.0"
        focus = "community governance"
        artifacts = "GOVERNANCE.md; STYLE_GUIDE.md; REVIEW_CHECKLIST.md; tools/check-community.ps1"
    },
    [pscustomobject]@{
        version = "v1.8.0"
        channel = "project"
        status = "stable"
        core = "v1.0.0"
        focus = "local portal serving"
        artifacts = "tools/serve-site.ps1; release metadata"
    },
    [pscustomobject]@{
        version = "v1.7.0"
        channel = "project"
        status = "stable"
        core = "v1.0.0"
        focus = "public portal"
        artifacts = "RELEASES.tsv; filtered site portal; portal checks"
    },
    [pscustomobject]@{
        version = "v1.6.0"
        channel = "project"
        status = "stable"
        core = "v1.0.0"
        focus = "lexicon governance"
        artifacts = "LEXICON_POLICY.md; tools/check-lexicon.ps1; lexicon metadata"
    },
    [pscustomobject]@{
        version = "v1.5.0"
        channel = "project"
        status = "stable"
        core = "v1.0.0"
        focus = "levelled corpus"
        artifacts = "CORPUS.tsv; DIALOGUES.tsv; level metadata"
    },
    [pscustomobject]@{
        version = "v1.4.0"
        channel = "project"
        status = "stable"
        core = "v1.0.0"
        focus = "grammar validation"
        artifacts = "tools/check-grammar.ps1; GitHub Actions release check"
    },
    [pscustomobject]@{
        version = "v1.3.0"
        channel = "project"
        status = "stable"
        core = "v1.0.0"
        focus = "learning system"
        artifacts = "COURSE.md; REFERENCE.md; FLASHCARDS.tsv"
    },
    [pscustomobject]@{
        version = "v1.2.0"
        channel = "project"
        status = "stable"
        core = "v1.0.0"
        focus = "corpus and community workflow"
        artifacts = "CORPUS.tsv; DIALOGUES.tsv; PROMPTS.md"
    },
    [pscustomobject]@{
        version = "v1.1.0"
        channel = "project"
        status = "stable"
        core = "v1.0.0"
        focus = "public launch kit"
        artifacts = "index.html; tools/aru-tool.ps1; expanded PHRASEBOOK.tsv"
    },
    [pscustomobject]@{
        version = "v1.0.0"
        channel = "language"
        status = "stable"
        core = "v1.0.0"
        focus = "stable language core"
        artifacts = "SPEC.md; LEXICON.tsv; PHRASEBOOK.tsv; custom license"
    }
)

$columns = @("version", "channel", "status", "core", "focus", "artifacts")
$lines = @($columns -join "`t")
foreach ($release in $releases) {
    $lines += (($columns | ForEach-Object { Clean $release.$_ }) -join "`t")
}

Set-Content -Path (Join-Path $root "RELEASES.tsv") -Value $lines -Encoding utf8
Write-Output "Generated RELEASES.tsv: $($releases.Count) releases"
