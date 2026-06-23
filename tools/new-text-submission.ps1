param(
    [ValidateSet("phrase", "corpus", "dialogue", "prompt")]
    [string]$Type = "corpus",
    [ValidateSet("A0", "A1", "A2", "B1")]
    [string]$Level = "A1",
    [string]$Topic = "draft",
    [Parameter(Mandatory = $true)]
    [string]$Aru,
    [Parameter(Mandatory = $true)]
    [string]$En,
    [string]$Notes = "Draft text",
    [ValidateSet("draft", "review", "accepted", "rejected")]
    [string]$Status = "draft",
    [string]$Id,
    [switch]$Append
)

$ErrorActionPreference = "Stop"

$root = Split-Path -Parent $PSScriptRoot
$queuePath = Join-Path $root "TEXT_SUBMISSIONS.tsv"

function Fail($message) {
    Write-Error $message
    exit 1
}

function Clean($value) {
    return (($value -replace "`t", " ") -replace "\r?\n", " ").Trim()
}

if (!(Test-Path $queuePath)) {
    Fail "TEXT_SUBMISSIONS.tsv is missing."
}

if ($Topic -notmatch '^[a-z0-9-]+$') {
    Fail "Topic should be lowercase letters, digits, or hyphens."
}

if (!$Id) {
    $rows = @(Import-Csv -Delimiter "`t" $queuePath)
    $last = 0
    foreach ($row in $rows) {
        if ($row.id -match '^S(\d+)$') {
            $last = [Math]::Max($last, [int]$matches[1])
        }
    }
    $Id = "S{0:000}" -f ($last + 1)
}

if ($Id -notmatch '^S\d{3}$') {
    Fail "ID should use S001 format."
}

$values = @($Id, $Type, $Level, $Topic, $Aru, $En, $Notes, $Status) | ForEach-Object { Clean $_ }
$line = $values -join "`t"

if ($Append) {
    Add-Content -Path $queuePath -Value $line -Encoding utf8
    Write-Output "Appended text submission: $Id"
} else {
    Write-Output "id	type	level	topic	aru	en	notes	status"
    Write-Output $line
}
