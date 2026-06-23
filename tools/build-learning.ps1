$ErrorActionPreference = "Stop"

$root = Split-Path -Parent $PSScriptRoot
$lexicon = Import-Csv -Delimiter "`t" (Join-Path $root "LEXICON.tsv")
$phrasebook = Import-Csv -Delimiter "`t" (Join-Path $root "PHRASEBOOK.tsv")

function Clean($value) {
    return (($value -replace "`t", " ") -replace "\r?\n", " ").Trim()
}

$rows = @()
$id = 1

foreach ($entry in $lexicon) {
    $rows += [pscustomobject]@{
        id = ("C{0:000}" -f $id)
        deck = "core-lexicon"
        front = $entry.root
        back = $entry.meaning
        tags = "root $($entry.category) $($entry.domain) $($entry.level) $($entry.status)"
    }
    $id++
}

foreach ($phrase in $phrasebook) {
    $rows += [pscustomobject]@{
        id = ("C{0:000}" -f $id)
        deck = "phrasebook"
        front = $phrase.aru
        back = $phrase.en
        tags = "phrase $($phrase.topic)"
    }
    $id++
}

$lines = @("id`tdeck`tfront`tback`ttags")
foreach ($row in $rows) {
    $lines += ((Clean $row.id), (Clean $row.deck), (Clean $row.front), (Clean $row.back), (Clean $row.tags)) -join "`t"
}

Set-Content -Path (Join-Path $root "FLASHCARDS.tsv") -Value $lines -Encoding utf8
Write-Output "Generated FLASHCARDS.tsv: $($rows.Count) cards"
