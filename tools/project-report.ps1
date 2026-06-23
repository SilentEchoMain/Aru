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

function Level-Counts($rows) {
    return @($rows | Group-Object level | Sort-Object Name | ForEach-Object {
        [pscustomobject]@{
            level = $_.Name
            count = $_.Count
        }
    })
}

function Count-By($rows, $property) {
    return @($rows | Group-Object $property | Sort-Object Name | ForEach-Object {
        [pscustomobject]@{
            name = $_.Name
            count = $_.Count
        }
    })
}

$lexicon = Read-Tsv "LEXICON.tsv"
$phrasebook = Read-Tsv "PHRASEBOOK.tsv"
$corpus = Read-Tsv "CORPUS.tsv"
$dialogues = Read-Tsv "DIALOGUES.tsv"
$flashcards = Read-Tsv "FLASHCARDS.tsv"
$releases = Read-Tsv "RELEASES.tsv"
$textSubmissions = Read-Tsv "TEXT_SUBMISSIONS.tsv"
$benchmark = Read-Tsv "TRANSLATION_BENCH.tsv"
$promptContent = Get-Content (Join-Path $root "PROMPTS.md") -Raw
$promptCount = ([regex]::Matches($promptContent, "(?m)^## Prompt \d+")).Count
$courseContent = Get-Content (Join-Path $root "COURSE.md") -Raw
$courseLessonCount = ([regex]::Matches($courseContent, "(?m)^## Lesson \d+")).Count

$report = [pscustomobject]@{
    languageCore = "v1.0.0"
    projectRelease = "v1.12.0"
    lexiconEntries = $lexicon.Count
    phrasebookEntries = $phrasebook.Count
    corpusTexts = $corpus.Count
    dialogues = $dialogues.Count
    writingPrompts = $promptCount
    courseLessons = $courseLessonCount
    flashcards = $flashcards.Count
    releases = $releases.Count
    currentRelease = (@($releases | Where-Object { $_.status -eq "current" })[0]).version
    textSubmissions = $textSubmissions.Count
    textSubmissionStatuses = Count-By $textSubmissions "status"
    textSubmissionTypes = Count-By $textSubmissions "type"
    benchmarkRows = $benchmark.Count
    benchmarkLevels = Count-By $benchmark "level"
    benchmarkDomains = Count-By $benchmark "domain"
    benchmarkPhenomena = Count-By $benchmark "phenomenon"
    lexiconStatuses = Count-By $lexicon "status"
    lexiconDomains = Count-By $lexicon "domain"
    lexiconLevels = Count-By $lexicon "level"
    phrasebookTopics = Topic-Counts $phrasebook
    corpusTopics = Topic-Counts $corpus
    dialogueTopics = Topic-Counts $dialogues
    corpusLevels = Level-Counts $corpus
    dialogueLevels = Level-Counts $dialogues
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
    Write-Output "Release entries: $($report.releases)"
    Write-Output "Current release: $($report.currentRelease)"
    Write-Output "Text submissions: $($report.textSubmissions)"
    Write-Output "Benchmark rows: $($report.benchmarkRows)"
    Write-Output ""
    Write-Output "Lexicon statuses:"
    $report.lexiconStatuses | Format-Table -AutoSize
    Write-Output "Lexicon domains:"
    $report.lexiconDomains | Format-Table -AutoSize
    Write-Output "Lexicon levels:"
    $report.lexiconLevels | Format-Table -AutoSize
    Write-Output "Text submission statuses:"
    $report.textSubmissionStatuses | Format-Table -AutoSize
    Write-Output "Text submission types:"
    $report.textSubmissionTypes | Format-Table -AutoSize
    Write-Output "Benchmark levels:"
    $report.benchmarkLevels | Format-Table -AutoSize
    Write-Output "Benchmark phenomena:"
    $report.benchmarkPhenomena | Format-Table -AutoSize
    Write-Output ""
    Write-Output "Top phrasebook topics:"
    $report.phrasebookTopics | Select-Object -First 10 | Format-Table -AutoSize
    Write-Output "Top corpus topics:"
    $report.corpusTopics | Select-Object -First 10 | Format-Table -AutoSize
    Write-Output "Corpus levels:"
    $report.corpusLevels | Format-Table -AutoSize
    Write-Output "Dialogue levels:"
    $report.dialogueLevels | Format-Table -AutoSize
    Write-Output "Flashcard decks:"
    $report.flashcardDecks | Format-Table -AutoSize
}
