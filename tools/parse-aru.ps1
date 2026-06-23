param(
    [string]$Text,
    [switch]$Json
)

$ErrorActionPreference = "Stop"

$root = Split-Path -Parent $PSScriptRoot
$lexiconPath = Join-Path $root "LEXICON.tsv"

function Get-AruTokenList($value) {
    return @(($value -replace '[\.,\?!:;\(\)\[\]\{\}"'']', ' ') -split '\s+' | Where-Object { $_ })
}

function Split-AruStatementText($value) {
    return @($value -split '(?<=[\.\?!])\s+' | ForEach-Object { $_.Trim() } | Where-Object { $_ })
}

function New-RootSet {
    if (!(Test-Path $lexiconPath)) {
        throw "LEXICON.tsv is missing."
    }
    $roots = @{}
    foreach ($row in @(Import-Csv -Delimiter "`t" $lexiconPath)) {
        $roots[$row.root] = $true
    }
    return $roots
}

function Get-AruKind($tokens) {
    if ($tokens.Count -eq 0) {
        return "empty"
    }
    if ($tokens[0] -eq "ka") {
        return "yesno_question"
    }
    if ($tokens[0] -eq "se" -and ($tokens -contains "ra")) {
        return "unknown_question"
    }
    $oIndex = [Array]::IndexOf($tokens, "o")
    if ($oIndex -eq 0 -or $oIndex -eq 1) {
        return "imperative"
    }
    return "declarative"
}

function Test-AruTerminal($token) {
    return @("ra", "ke", "ne", "le", "re", "to", "ko", "so", "we", "pasu", "an", "alo", "sia", "tune") -contains $token
}

function Parse-AruStatement {
    param(
        [string]$Statement,
        [hashtable]$Roots
    )

    $tokens = @(Get-AruTokenList $Statement)
    $issues = New-Object System.Collections.Generic.List[string]
    $features = New-Object System.Collections.Generic.List[string]

    if ($tokens.Count -eq 0) {
        $issues.Add("empty statement") | Out-Null
        return [pscustomobject]@{
            text = $Statement
            ok = $false
            kind = "empty"
            tokens = $tokens
            features = @()
            issues = @($issues)
        }
    }

    $kind = Get-AruKind $tokens
    $raIndexes = @(0..($tokens.Count - 1) | Where-Object { $tokens[$_] -eq "ra" })
    $oIndex = [Array]::IndexOf($tokens, "o")

    if ($kind -eq "imperative") {
        $features.Add("imperative") | Out-Null
        if ($tokens.Count -le ($oIndex + 1)) {
            $issues.Add("o must be followed by an imperative predicate") | Out-Null
        }
        if ($tokens -contains "ra") {
            $issues.Add("imperative should not use ra") | Out-Null
        }
    } else {
        if ($raIndexes.Count -eq 0) {
            $issues.Add("statement has no predicate boundary") | Out-Null
        } elseif ($raIndexes[0] -eq 0) {
            $issues.Add("ra needs a subject or frame before it") | Out-Null
        }
    }

    if ($kind -eq "yesno_question") {
        $features.Add("yesno") | Out-Null
        if ($raIndexes.Count -eq 0) {
            $issues.Add("yes/no question needs ra") | Out-Null
        }
    }
    if ($kind -eq "unknown_question") {
        $features.Add("unknown") | Out-Null
    }

    if ($oIndex -gt 1) {
        $issues.Add("o should open an imperative after an optional address") | Out-Null
    }

    for ($i = 0; $i -lt $tokens.Count; $i++) {
        $token = $tokens[$i]

        if ($token -eq "ya") {
            $features.Add("name") | Out-Null
            if ($i -eq ($tokens.Count - 1)) {
                $issues.Add("ya must be followed by a name") | Out-Null
            } else {
                $i++
            }
            continue
        }

        if ($token -eq "saka") {
            $features.Add("quantity") | Out-Null
            if ($i -eq ($tokens.Count - 1) -or $tokens[$i + 1] -notmatch '^\d+$') {
                $issues.Add("saka must be followed by exact digits") | Out-Null
            } else {
                $i++
            }
            continue
        }

        if ($token -match '^\d+$') {
            continue
        }

        if (!$Roots.ContainsKey($token)) {
            $issues.Add("unknown token: $token") | Out-Null
            continue
        }

        if ((Test-AruTerminal $token) -and $i -eq ($tokens.Count - 1)) {
            $issues.Add("$token cannot end a statement") | Out-Null
        }

        if ($token -eq "ka" -and $i -ne 0) {
            $issues.Add("ka should open a yes/no question") | Out-Null
        }

        if ($token -eq "ke") {
            $features.Add("object") | Out-Null
            if ($i -eq ($tokens.Count - 1)) {
                $issues.Add("ke must be followed by an object") | Out-Null
            } elseif (@("ra", "ke", "le", "re", "an", "alo", "sia", "tune", "pasu") -contains $tokens[$i + 1]) {
                $issues.Add("ke cannot be followed by $($tokens[$i + 1])") | Out-Null
            }
        }

        if (@("to", "ko", "so", "we", "ne") -contains $token) {
            $features.Add("relation") | Out-Null
        }

        if (@("pa", "nu", "po") -contains $token) {
            $features.Add("time") | Out-Null
        }

        if ($token -eq "no") {
            $features.Add("negation") | Out-Null
        }

        if ($token -eq "le") {
            $features.Add("context") | Out-Null
        }

        if ($token -eq "re") {
            $features.Add("relative") | Out-Null
            $tail = @($tokens[($i + 1)..($tokens.Count - 1)])
            if ($tail -notcontains "ri") {
                $issues.Add("re must contain ri later in the same statement") | Out-Null
            }
        }

        if ($token -eq "ri") {
            $features.Add("relative") | Out-Null
            $head = @($tokens[0..$i])
            if ($head -notcontains "re") {
                $issues.Add("ri appears outside a re phrase") | Out-Null
            }
        }

        if ($token -eq "pasu") {
            $features.Add("comparison") | Out-Null
        }

        if (@("an", "alo", "sia", "tune") -contains $token) {
            $features.Add("coordination") | Out-Null
        }
    }

    for ($i = 0; $i -le ($tokens.Count - 3); $i++) {
        if ($tokens[$i] -eq "ke" -and $tokens[$i + 1] -eq "i" -and $tokens[$i + 2] -eq "le") {
            $features.Add("content") | Out-Null
        }
    }

    if ($raIndexes.Count -gt 0) {
        $features.Add("predicate") | Out-Null
    }

    return [pscustomobject]@{
        text = $Statement
        ok = ($issues.Count -eq 0)
        kind = $kind
        tokens = $tokens
        features = @($features | Sort-Object -Unique)
        issues = @($issues | Sort-Object -Unique)
    }
}

function Parse-AruText {
    param(
        [string]$Value
    )

    $roots = New-RootSet
    $statements = @(Split-AruStatementText $Value | ForEach-Object { Parse-AruStatement -Statement $_ -Roots $roots })
    $issueCount = 0
    foreach ($statement in $statements) {
        $issueCount += $statement.issues.Count
    }

    return [pscustomobject]@{
        ok = ($issueCount -eq 0 -and $statements.Count -gt 0)
        statementCount = $statements.Count
        issueCount = $issueCount
        statements = $statements
    }
}

if ($Text) {
    $result = Parse-AruText $Text
    if ($Json) {
        $result | ConvertTo-Json -Depth 8
    } else {
        Write-Output "Aru parse result"
        Write-Output "OK: $($result.ok)"
        Write-Output "Statements: $($result.statementCount)"
        Write-Output "Issues: $($result.issueCount)"
        $result.statements | Select-Object text, ok, kind, @{Name = "features"; Expression = { $_.features -join "," } }, @{Name = "issues"; Expression = { $_.issues -join "; " } } | Format-Table -AutoSize
    }
}
