param(
    [string]$Text,
    [string]$Search,
    [switch]$Phrases,
    [switch]$Corpus,
    [switch]$Dialogues,
    [switch]$Cards,
    [switch]$Releases,
    [switch]$Submissions,
    [switch]$Benchmark,
    [switch]$Challenges,
    [switch]$Conformance,
    [switch]$Json
)

$ErrorActionPreference = "Stop"

$root = Split-Path -Parent $PSScriptRoot
$lexiconPath = Join-Path $root "LEXICON.tsv"
$phrasebookPath = Join-Path $root "PHRASEBOOK.tsv"
$corpusPath = Join-Path $root "CORPUS.tsv"
$dialoguesPath = Join-Path $root "DIALOGUES.tsv"
$flashcardsPath = Join-Path $root "FLASHCARDS.tsv"
$releasesPath = Join-Path $root "RELEASES.tsv"
$submissionsPath = Join-Path $root "TEXT_SUBMISSIONS.tsv"
$benchmarkPath = Join-Path $root "TRANSLATION_BENCH.tsv"
$challengesPath = Join-Path $root "COMMUNITY_CHALLENGES.tsv"
$conformancePath = Join-Path $root "CONFORMANCE.tsv"

function Fail($message) {
    Write-Error $message
    exit 1
}

if (!(Test-Path $lexiconPath)) {
    Fail "LEXICON.tsv is missing."
}
if (!(Test-Path $phrasebookPath)) {
    Fail "PHRASEBOOK.tsv is missing."
}
if (!(Test-Path $corpusPath)) {
    Fail "CORPUS.tsv is missing."
}
if (!(Test-Path $dialoguesPath)) {
    Fail "DIALOGUES.tsv is missing."
}
if (!(Test-Path $flashcardsPath)) {
    Fail "FLASHCARDS.tsv is missing."
}
if (!(Test-Path $releasesPath)) {
    Fail "RELEASES.tsv is missing."
}
if (!(Test-Path $submissionsPath)) {
    Fail "TEXT_SUBMISSIONS.tsv is missing."
}
if (!(Test-Path $benchmarkPath)) {
    Fail "TRANSLATION_BENCH.tsv is missing."
}
if (!(Test-Path $challengesPath)) {
    Fail "COMMUNITY_CHALLENGES.tsv is missing."
}
if (!(Test-Path $conformancePath)) {
    Fail "CONFORMANCE.tsv is missing."
}

$lexicon = Import-Csv -Delimiter "`t" $lexiconPath
$phrasebook = Import-Csv -Delimiter "`t" $phrasebookPath
$corpusRows = Import-Csv -Delimiter "`t" $corpusPath
$dialogueRows = Import-Csv -Delimiter "`t" $dialoguesPath
$flashcardRows = Import-Csv -Delimiter "`t" $flashcardsPath
$releaseRows = Import-Csv -Delimiter "`t" $releasesPath
$submissionRows = Import-Csv -Delimiter "`t" $submissionsPath
$benchmarkRows = Import-Csv -Delimiter "`t" $benchmarkPath
$challengeRows = Import-Csv -Delimiter "`t" $challengesPath
$conformanceRows = Import-Csv -Delimiter "`t" $conformancePath
$roots = @{}
foreach ($row in $lexicon) {
    $roots[$row.root] = $row
}

$wordShape = "^(?:[aeiou]n|[ptkmnslrwy][aeiou]n|[aeiou]|[ptkmnslrwy][aeiou])+$"

function Get-AruTokens($value) {
    return (($value -replace '[\.,\?!:;\(\)\[\]\{\}"'']', ' ') -split '\s+' | Where-Object { $_ })
}

function Test-AruText($value) {
    $tokens = @(Get-AruTokens $value)
    $unknown = @()
    $names = @()
    $numbers = @()
    $skipName = $false
    $skipNumber = $false

    foreach ($token in $tokens) {
        if ($skipName) {
            $names += $token
            $skipName = $false
            continue
        }
        if ($skipNumber) {
            if ($token -match '^\d+$') {
                $numbers += $token
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
            $numbers += $token
            continue
        }
        if (!$roots.ContainsKey($token)) {
            $unknown += [pscustomobject]@{
                token = $token
                shapeOk = [bool]($token -match $wordShape)
            }
        }
    }

    return [pscustomobject]@{
        tokens = $tokens
        tokenCount = $tokens.Count
        names = $names
        numbers = $numbers
        unknown = $unknown
        ok = ($unknown.Count -eq 0)
    }
}

if ($Search) {
    $needle = $Search.ToLowerInvariant()
    if ($Cards) {
        $matches = @($flashcardRows | Where-Object {
            ($_.id + " " + $_.deck + " " + $_.front + " " + $_.back + " " + $_.tags).ToLowerInvariant().Contains($needle)
        })
    } elseif ($Releases) {
        $matches = @($releaseRows | Where-Object {
            ($_.version + " " + $_.channel + " " + $_.status + " " + $_.core + " " + $_.focus + " " + $_.artifacts).ToLowerInvariant().Contains($needle)
        })
    } elseif ($Submissions) {
        $matches = @($submissionRows | Where-Object {
            ($_.id + " " + $_.type + " " + $_.level + " " + $_.topic + " " + $_.aru + " " + $_.en + " " + $_.notes + " " + $_.status).ToLowerInvariant().Contains($needle)
        })
    } elseif ($Benchmark) {
        $matches = @($benchmarkRows | Where-Object {
            ($_.id + " " + $_.level + " " + $_.domain + " " + $_.phenomenon + " " + $_.source_en + " " + $_.reference_aru + " " + $_.notes).ToLowerInvariant().Contains($needle)
        })
    } elseif ($Challenges) {
        $matches = @($challengeRows | Where-Object {
            ($_.id + " " + $_.track + " " + $_.level + " " + $_.title + " " + $_.prompt + " " + $_.seed_aru + " " + $_.outcome + " " + $_.check + " " + $_.status).ToLowerInvariant().Contains($needle)
        })
    } elseif ($Conformance) {
        $matches = @($conformanceRows | Where-Object {
            ($_.id + " " + $_.expected + " " + $_.level + " " + $_.feature + " " + $_.text + " " + $_.expected_kind + " " + $_.notes).ToLowerInvariant().Contains($needle)
        })
    } elseif ($Corpus) {
        $matches = @($corpusRows | Where-Object {
            ($_.id + " " + $_.level + " " + $_.topic + " " + $_.aru + " " + $_.en + " " + $_.notes).ToLowerInvariant().Contains($needle)
        })
    } elseif ($Dialogues) {
        $matches = @($dialogueRows | Where-Object {
            ($_.id + " " + $_.level + " " + $_.topic + " " + $_.aru + " " + $_.en + " " + $_.notes).ToLowerInvariant().Contains($needle)
        })
    } elseif ($Phrases) {
        $matches = @($phrasebook | Where-Object {
            ($_.id + " " + $_.topic + " " + $_.aru + " " + $_.en).ToLowerInvariant().Contains($needle)
        })
    } else {
        $matches = @($lexicon | Where-Object {
            ($_.id + " " + $_.root + " " + $_.category + " " + $_.domain + " " + $_.level + " " + $_.status + " " + $_.introduced + " " + $_.meaning + " " + $_.notes).ToLowerInvariant().Contains($needle)
        })
    }

    if ($Json) {
        $matches | ConvertTo-Json -Depth 4
    } else {
        $matches | Format-Table -AutoSize
    }
    exit 0
}

if (!$Text) {
    Write-Output "Usage:"
    Write-Output "  .\tools\aru-tool.ps1 -Text 'na ra waro.'"
    Write-Output "  .\tools\aru-tool.ps1 -Search waro"
    Write-Output "  .\tools\aru-tool.ps1 -Search house -Phrases"
    Write-Output "  .\tools\aru-tool.ps1 -Search community -Corpus"
    Write-Output "  .\tools\aru-tool.ps1 -Search meeting -Dialogues"
    Write-Output "  .\tools\aru-tool.ps1 -Search waro -Cards"
    Write-Output "  .\tools\aru-tool.ps1 -Search portal -Releases"
    Write-Output "  .\tools\aru-tool.ps1 -Search draft -Submissions"
    Write-Output "  .\tools\aru-tool.ps1 -Search relative -Benchmark"
    Write-Output "  .\tools\aru-tool.ps1 -Search writing -Challenges"
    Write-Output "  .\tools\aru-tool.ps1 -Search invalid -Conformance"
    exit 0
}

$result = Test-AruText $Text
if ($Json) {
    $result | ConvertTo-Json -Depth 6
} else {
    if ($result.ok) {
        Write-Output "OK: all checked tokens are in the core lexicon."
    } else {
        Write-Output ("Unknown tokens: " + (($result.unknown | ForEach-Object { $_.token }) -join ", "))
    }
    Write-Output ("Token count: " + $result.tokenCount)
    if ($result.names.Count -gt 0) {
        Write-Output ("Names: " + ($result.names -join ", "))
    }
    if ($result.numbers.Count -gt 0) {
        Write-Output ("Numbers: " + ($result.numbers -join ", "))
    }
}
