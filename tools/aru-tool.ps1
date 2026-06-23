param(
    [string]$Text,
    [string]$Search,
    [switch]$Phrases,
    [switch]$Json
)

$ErrorActionPreference = "Stop"

$root = Split-Path -Parent $PSScriptRoot
$lexiconPath = Join-Path $root "LEXICON.tsv"
$phrasebookPath = Join-Path $root "PHRASEBOOK.tsv"

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

$lexicon = Import-Csv -Delimiter "`t" $lexiconPath
$phrasebook = Import-Csv -Delimiter "`t" $phrasebookPath
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
    if ($Phrases) {
        $matches = @($phrasebook | Where-Object {
            ($_.id + " " + $_.topic + " " + $_.aru + " " + $_.en).ToLowerInvariant().Contains($needle)
        })
    } else {
        $matches = @($lexicon | Where-Object {
            ($_.root + " " + $_.category + " " + $_.meaning + " " + $_.notes).ToLowerInvariant().Contains($needle)
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
