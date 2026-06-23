$ErrorActionPreference = "Stop"

$root = Split-Path -Parent $PSScriptRoot
$issues = New-Object System.Collections.Generic.List[object]
$stats = [ordered]@{
    datasets = 0
    rows = 0
    statements = 0
    tokens = 0
    markdownExamples = 0
}

function Fail($message) {
    Write-Error $message
    exit 1
}

function Add-Issue($source, $id, $message, $text) {
    $issues.Add([pscustomobject]@{
        source = $source
        id = $id
        message = $message
        text = $text
    }) | Out-Null
}

function Read-Tsv($name) {
    $path = Join-Path $root $name
    if (!(Test-Path $path)) {
        Fail "Missing file: $name"
    }
    return @(Import-Csv -Delimiter "`t" $path)
}

function Get-AruTokens($value) {
    return @(($value -replace '[\.,\?!:;\(\)\[\]\{\}"'']', ' ') -split '\s+' | Where-Object { $_ })
}

function Split-AruStatements($value) {
    return @($value -split '(?<=[\.\?!])\s+' | ForEach-Object { $_.Trim() } | Where-Object { $_ })
}

$lexicon = Read-Tsv "LEXICON.tsv"
$roots = @{}
foreach ($row in $lexicon) {
    $roots[$row.root] = $true
}

function Test-AruStatement($source, $id, $text) {
    $tokens = @(Get-AruTokens $text)
    if ($tokens.Count -eq 0) {
        return
    }

    $stats.statements++
    $stats.tokens += $tokens.Count

    $hasRa = $tokens -contains "ra"
    $hasImperative = $tokens -contains "o"
    if (!$hasRa -and !$hasImperative) {
        Add-Issue $source $id "statement has no predicate boundary or imperative marker" $text
    }

    for ($i = 0; $i -lt $tokens.Count; $i++) {
        $token = $tokens[$i]

        if ($token -eq "ya") {
            if ($i -eq ($tokens.Count - 1)) {
                Add-Issue $source $id "ya must be followed by a name" $text
            } else {
                $i++
            }
            continue
        }

        if ($token -eq "saka") {
            if ($i -eq ($tokens.Count - 1) -or $tokens[$i + 1] -notmatch '^\d+$') {
                Add-Issue $source $id "saka must be followed by exact digits" $text
            } else {
                $i++
            }
            continue
        }

        if ($token -match '^\d+$') {
            continue
        }

        if (!$roots.ContainsKey($token)) {
            Add-Issue $source $id "unknown token: $token" $text
            continue
        }

        if (($token -eq "ra" -or $token -eq "ke" -or $token -eq "le" -or $token -eq "re") -and $i -eq ($tokens.Count - 1)) {
            Add-Issue $source $id "$token cannot end a statement" $text
        }

        if ($token -eq "re") {
            $tail = @($tokens[($i + 1)..($tokens.Count - 1)])
            if ($tail -notcontains "ri") {
                Add-Issue $source $id "re must contain ri later in the same statement" $text
            }
        }

        if ($token -eq "ri") {
            $head = @($tokens[0..$i])
            if ($head -notcontains "re") {
                Add-Issue $source $id "ri appears outside a re phrase" $text
            }
        }

        if ($token -eq "ka" -and $i -ne 0) {
            Add-Issue $source $id "ka should open a yes/no question" $text
        }

        if ($token -eq "o" -and $i -eq ($tokens.Count - 1)) {
            Add-Issue $source $id "o must be followed by an imperative predicate" $text
        }
    }
}

function Test-AruDataset($name, $rows) {
    $stats.datasets++
    foreach ($row in $rows) {
        $stats.rows++
        foreach ($statement in Split-AruStatements $row.aru) {
            Test-AruStatement $name $row.id $statement
        }
    }
}

function Test-MarkdownExamples($name) {
    $path = Join-Path $root $name
    if (!(Test-Path $path)) {
        return
    }

    $inBlock = $false
    $lineNumber = 0
    foreach ($line in Get-Content $path) {
        $lineNumber++
        $trimmed = $line.Trim()
        if ($trimmed -match '^```') {
            $inBlock = !$inBlock
            continue
        }
        if (!$inBlock -or !$trimmed) {
            continue
        }
        if ($trimmed -notmatch '[\.\?!]$') {
            continue
        }
        if ($trimmed -match 'subject|predicate|object|sentence|head|root|particle|function|pattern|example|answer|->|\||/|=|X|Y|Q') {
            continue
        }
        if ($trimmed -notmatch '(^|\s)(ra|o)(\s|$)|^ka\s|^se\s+ra\s') {
            continue
        }
        $stats.markdownExamples++
        Test-AruStatement $name "line $lineNumber" $trimmed
    }
}

Test-AruDataset "PHRASEBOOK.tsv" (Read-Tsv "PHRASEBOOK.tsv")
Test-AruDataset "CORPUS.tsv" (Read-Tsv "CORPUS.tsv")
Test-AruDataset "DIALOGUES.tsv" (Read-Tsv "DIALOGUES.tsv")

foreach ($doc in @("COURSE.md", "REFERENCE.md", "EXAMPLES.md", "SPEC.md")) {
    Test-MarkdownExamples $doc
}

if ($issues.Count -gt 0) {
    Write-Output "Aru grammar check failed."
    $issues | Format-Table -AutoSize
    exit 1
}

Write-Output "Aru grammar check passed."
Write-Output "Datasets: $($stats.datasets)"
Write-Output "Rows: $($stats.rows)"
Write-Output "Statements: $($stats.statements)"
Write-Output "Tokens checked: $($stats.tokens)"
Write-Output "Markdown examples checked: $($stats.markdownExamples)"
