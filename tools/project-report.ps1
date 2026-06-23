param(
    [switch]$Json
)

$ErrorActionPreference = "Stop"

$root = Split-Path -Parent $PSScriptRoot

function Read-Tsv($name) {
    $path = Join-Path $root $name
    if (!(Test-Path $path)) {
        throw "Missing file: $name"
    }
    return @(Import-Csv -Delimiter "`t" $path)
}

function Topic-Counts($rows) {
    return @($rows | Group-Object topic | Sort-Object Count -Descending | ForEach-Object {
        [pscustomobject]@{
            topic = $_.Name
            count = $_.Count
        }
    })
}

$lexicon = Read-Tsv "LEXICON.tsv"
$phrasebook = Read-Tsv "PHRASEBOOK.tsv"
$corpus = Read-Tsv "CORPUS.tsv"
$dialogues = Read-Tsv "DIALOGUES.tsv"
$flashcards = Read-Tsv "FLASHCARDS.tsv"
$promptContent = Get-Content (Join-Path $root "PROMPTS.md") -Raw
$promptCount = ([regex]::Matches($promptContent, "(?m)^## Prompt \d+")).Count
$courseContent = Get-Content (Join-Path $root "COURSE.md") -Raw
$courseLessonCount = ([regex]::Matches($courseContent, "(?m)^## Lesson \d+")).Count

$report = [pscustomobject]@{
    languageCore = "v1.0.0"
    projectRelease = "v1.3.0"
    lexiconEntries = $lexicon.Count
    phrasebookEntries = $phrasebook.Count
    corpusTexts = $corpus.Count
    dialogues = $dialogues.Count
    writingPrompts = $promptCount
    courseLessons = $courseLessonCount
    flashcards = $flashcards.Count
    phrasebookTopics = Topic-Counts $phrasebook
    corpusTopics = Topic-Counts $corpus
    dialogueTopics = Topic-Counts $dialogues
    flashcardDecks = @($flashcards | Group-Object deck | Sort-Object Count -Descending | ForEach-Object {
        [pscustomobject]@{
            deck = $_.Name
            count = $_.Count
        }
    })
}

if ($Json) {
    $report | ConvertTo-Json -Depth 8
} else {
    Write-Output "Aru Project Report"
    Write-Output "Language core: $($report.languageCore)"
    Write-Output "Project release: $($report.projectRelease)"
    Write-Output "Lexicon entries: $($report.lexiconEntries)"
    Write-Output "Phrasebook entries: $($report.phrasebookEntries)"
    Write-Output "Corpus texts: $($report.corpusTexts)"
    Write-Output "Dialogues: $($report.dialogues)"
    Write-Output "Writing prompts: $($report.writingPrompts)"
    Write-Output "Course lessons: $($report.courseLessons)"
    Write-Output "Flashcards: $($report.flashcards)"
    Write-Output ""
    Write-Output "Top phrasebook topics:"
    $report.phrasebookTopics | Select-Object -First 10 | Format-Table -AutoSize
    Write-Output "Top corpus topics:"
    $report.corpusTopics | Select-Object -First 10 | Format-Table -AutoSize
    Write-Output "Flashcard decks:"
    $report.flashcardDecks | Format-Table -AutoSize
}
