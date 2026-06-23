$ErrorActionPreference = "Stop"

$root = Split-Path -Parent $PSScriptRoot

function Write-Tsv($path, $rows, $columns) {
    $lines = @()
    $lines += ($columns -join "`t")
    foreach ($row in $rows) {
        $values = foreach ($column in $columns) {
            (($row.$column -replace "`t", " ") -replace "\r?\n", " ")
        }
        $lines += ($values -join "`t")
    }
    Set-Content -Path $path -Value $lines -Encoding utf8
}

$people = @(
    @{ aru = "mene"; en = "person" },
    @{ aru = "melo"; en = "friend" },
    @{ aru = "senu"; en = "teacher" },
    @{ aru = "kano"; en = "child" },
    @{ aru = "mamu"; en = "caretaker" }
)

$places = @(
    @{ aru = "malo"; en = "house" },
    @{ aru = "rano"; en = "river" },
    @{ aru = "pano"; en = "field" },
    @{ aru = "sara"; en = "mountain" },
    @{ aru = "mewa"; en = "sea" }
)

$objects = @(
    @{ aru = "tulu"; en = "tool" },
    @{ aru = "lipa"; en = "document" },
    @{ aru = "sipu"; en = "text" },
    @{ aru = "suko"; en = "container" },
    @{ aru = "poto"; en = "image" }
)

$qualities = @(
    @{ aru = "lisu"; en = "simple" },
    @{ aru = "nela"; en = "good" },
    @{ aru = "sini"; en = "new" },
    @{ aru = "kasa"; en = "hard" },
    @{ aru = "sene"; en = "quiet" }
)

$weather = @(
    @{ aru = "nilo"; en = "cold" },
    @{ aru = "pira"; en = "heat" },
    @{ aru = "roka"; en = "rain" },
    @{ aru = "kowa"; en = "wind" },
    @{ aru = "noki"; en = "darkness" }
)

$corpusRows = @()
for ($i = 1; $i -le 100; $i++) {
    $p = $people[($i - 1) % $people.Count]
    $q = $people[$i % $people.Count]
    $place = $places[($i + 1) % $places.Count]
    $obj = $objects[($i + 2) % $objects.Count]
    $qual = $qualities[($i + 3) % $qualities.Count]
    $w = $weather[($i + 4) % $weather.Count]

    switch (($i - 1) % 10) {
        0 {
            $topic = "daily-life"
            $level = "A0"
            $aru = "temu luma nu le, $($p.aru) ra waki. $($p.aru) ra taka ke $($obj.aru). $($p.aru) ra naka ko $($place.aru). $($q.aru) ra lano ke wai ko $($p.aru). $($p.aru) ra waro we $($q.aru)."
            $en = "Today the $($p.en) begins the day. The $($p.en) takes the $($obj.en). The $($p.en) goes to the $($place.en). The $($q.en) gives water to the $($p.en). The $($p.en) speaks with the $($q.en)."
        }
        1 {
            $topic = "learning"
            $level = "A1"
            $aru = "$($p.aru) ra nema ke ya Aru. $($p.aru) ra lowa ke naru ne waro. naru i ra $($qual.aru). $($p.aru) ra sawi ke pane. $($q.aru) ra pane ke $($p.aru)."
            $en = "The $($p.en) studies Aru. The $($p.en) reads the rules of speech. This rule is $($qual.en). The $($p.en) asks for an answer. The $($q.en) answers the $($p.en)."
        }
        2 {
            $topic = "tools"
            $level = "A1"
            $aru = "$($obj.aru) i ra ko waro. $($p.aru) ra sena ke $($obj.aru). $($obj.aru) ra pane ke i le, waro ra $($qual.aru). etu $($obj.aru) ra no sona le, $($p.aru) ra mela ke i. tulu ra wena ke $($p.aru)."
            $en = "This $($obj.en) is for speech. The $($p.en) tests the $($obj.en). The $($obj.en) answers that speech is $($qual.en). If the $($obj.en) does not know, the $($p.en) repairs it. A tool helps the $($p.en)."
        }
        3 {
            $topic = "weather"
            $level = "A1"
            $aru = "$($w.aru) ra tanu. $($p.aru) ra no naka so etu $($w.aru). $($q.aru) ra to insa malo. $($p.aru) ra waro ke i le, temu luma po le, $($p.aru) ra po naka. $($q.aru) ra lora ke $($p.aru)."
            $en = "$($w.en) comes. The $($p.en) does not go because of $($w.en). The $($q.en) is inside the house. The $($p.en) says that tomorrow the $($p.en) will go. The $($q.en) hears the $($p.en)."
        }
        4 {
            $topic = "relative"
            $level = "A2"
            $aru = "$($p.aru) re ri ra kipa ke $($obj.aru), ra $($qual.aru). $($q.aru) ra sela ke ena. $($p.aru) ra lano ke $($obj.aru) ko $($q.aru). $($q.aru) ra toma ke $($obj.aru). $($obj.aru) ra ne $($q.aru)."
            $en = "The $($p.en) who holds the $($obj.en) is $($qual.en). The $($q.en) sees that person. The $($p.en) gives the $($obj.en) to the $($q.en). The $($q.en) keeps the $($obj.en). The $($obj.en) is related to the $($q.en)."
        }
        5 {
            $topic = "comparison"
            $level = "A2"
            $aru = "$($place.aru) i ra maru pasu $($place.aru) ena. $($obj.aru) i ra $($qual.aru) pasu $($obj.aru) ena. $($p.aru) ra waro lisu pasu $($q.aru). $($q.aru) ra sona sama pasu $($p.aru). $($p.aru) ra rima sona waro nela."
            $en = "This $($place.en) is bigger than that $($place.en). This $($obj.en) is more $($qual.en) than that $($obj.en). The $($p.en) speaks more simply than the $($q.en). The $($q.en) knows as much as the $($p.en). The $($p.en) wants to know how to speak well."
        }
        6 {
            $topic = "community"
            $level = "A1"
            $aru = "kale ne ya Aru ra maku ke sipu. $($p.aru) ra raku ke sipu $($qual.aru). $($q.aru) ra lowa ke sipu. kale ra sena ke waro. waro i ra ruma nela."
            $en = "The Aru community makes a text. The $($p.en) writes a $($qual.en) text. The $($q.en) reads the text. The community tests speech. This speech becomes good."
        }
        7 {
            $topic = "public"
            $level = "A1"
            $aru = "sipu i ra puka. mene se ra tanu so tera para. mene se ra lowa ke sipu. u ra sawi ke naru se. kale ra pane ke u."
            $en = "This text is open. Someone comes from a far place. Someone reads the text. They ask for some rule. The community answers them."
        }
        8 {
            $topic = "repair"
            $level = "A1"
            $aru = "$($obj.aru) ra rupi. $($p.aru) ra taka ke $($obj.aru). $($p.aru) ra naka ko $($q.aru). $($q.aru) ra mela ke $($obj.aru). $($obj.aru) ra ruma pawa."
            $en = "The $($obj.en) is broken. The $($p.en) takes the $($obj.en). The $($p.en) goes to the $($q.en). The $($q.en) repairs the $($obj.en). The $($obj.en) becomes powerful."
        }
        default {
            $topic = "clear-speech"
            $level = "A2"
            $aru = "waro lisu ra nela. $($p.aru) ra no rima ke naru maru. $($p.aru) ra rima ke naru mini. etu $($q.aru) ra sona ke $($p.aru) le, $($p.aru) ra pawa waro. waro mini ra pawa."
            $en = "Simple speech is good. The $($p.en) does not want big rules. The $($p.en) wants small rules. If the $($q.en) understands the $($p.en), the $($p.en) can speak. Small speech is powerful."
        }
    }

    $corpusRows += [pscustomobject]@{
        id = ("T{0:000}" -f $i)
        level = $level
        topic = $topic
        aru = $aru
        en = $en
        notes = "Generated stable-core corpus text"
    }
}

$dialogueRows = @()
for ($i = 1; $i -le 30; $i++) {
    $p = $people[($i - 1) % $people.Count]
    $q = $people[$i % $people.Count]
    $place = $places[($i + 2) % $places.Count]
    $obj = $objects[($i + 3) % $objects.Count]
    switch (($i - 1) % 6) {
        0 {
            $topic = "meeting"
            $level = "A0"
            $aru = "lani ne ta ra se? lani ne na ra ya Mira. ta ra nema ke ya Aru? na ra nema ke ya Aru. o waro we na."
            $en = "What is your name? My name is Mira. Do you study Aru? I study Aru. Speak with me."
        }
        1 {
            $topic = "house"
            $level = "A1"
            $aru = "malo ne na ra kima. ka ta ra rima naka ko i? na ra rima naka ko i. ka malo ra nilo? malo ra nilo mini."
            $en = "My house is near. Do you want to go to it? I want to go to it. Is the house cold? The house is slightly cold."
        }
        2 {
            $topic = "tool"
            $level = "A1"
            $aru = "tulu i ra rupi. ta ra pawa mela ke i? na ra pawa mela ke i. o lano ke tulu ko na. na ra lano ke i ko ta."
            $en = "This tool is broken. Can you repair it? I can repair it. Give the tool to me. I give it to you."
        }
        3 {
            $topic = "learning"
            $level = "A1"
            $aru = "ta ra sona ke naru i? na ra sona ke naru mini. se ra kasa? sipu re ri ra ama ke naru mun, ra kasa. na ra sona."
            $en = "Do you know this rule? I know the small rule. What is hard? A text that has many rules is hard. I understand."
        }
        4 {
            $topic = "cause"
            $level = "A2"
            $aru = "ta ra pa no tanu so etu se? na ra pa no tanu so etu roka. temu luma po le, ta o tanu. na ra po tanu. na ra lora ke ta."
            $en = "Why did you not come? I did not come because of rain. Tomorrow, come. I will come. I hear you."
        }
        default {
            $topic = "public"
            $level = "A1"
            $aru = "sipu i ra puka. se ra lowa ke i? mene mun ra lowa ke i. ka sipu ra lisu? sipu ra lisu, tune sipu ra mini."
            $en = "This text is open. Who reads it? Many people read it. Is the text simple? The text is simple, but the text is small."
        }
    }

    $dialogueRows += [pscustomobject]@{
        id = ("D{0:000}" -f $i)
        level = $level
        topic = $topic
        aru = $aru
        en = $en
        notes = "Five-turn dialogue"
    }
}

$prompts = @(
    "Write five sentences about a house near water.",
    "Describe a person who learns Aru from a friend.",
    "Write a dialogue where one person asks why another did not come.",
    "Describe a broken tool and how someone repairs it.",
    "Write a short text using `ke i le` at least once.",
    "Write a short text using `re` and `ri` at least once.",
    "Compare two houses, two tools, or two people.",
    "Describe a cold day and a reason for not going somewhere.",
    "Write a public invitation for people to read an Aru text.",
    "Explain one Aru rule using only simple sentences.",
    "Write about a community making a shared text.",
    "Describe a journey from a house to a river.",
    "Write a short story with one person, one friend, and one tool.",
    "Use `an`, `tune`, and `sia` in three separate sentences.",
    "Write a text where someone forgets a name and asks again.",
    "Describe a teacher answering a new person's question.",
    "Write a text that contains a name marked with `ya`.",
    "Write a text with an exact number using `saka`.",
    "Write a quiet scene at night.",
    "Write a short manifesto for clear speech."
)

$promptLines = @("# Writing Prompts", "", "These prompts are designed to grow the Aru corpus without changing the v1.0.0 grammar.", "")
for ($i = 0; $i -lt $prompts.Count; $i++) {
    $num = $i + 1
    $starter = switch ($i % 5) {
        0 { "na ra raku ke sipu i." }
        1 { "mene se ra nema ke ya Aru." }
        2 { "ta ra sawi ke pane." }
        3 { "tulu i ra rupi." }
        default { "waro lisu ra nela." }
    }
    $promptLines += "## Prompt $num"
    $promptLines += ""
    $promptLines += $prompts[$i]
    $promptLines += ""
    $promptLines += "Starter:"
    $promptLines += ""
    $promptLines += '```text'
    $promptLines += $starter
    $promptLines += '```'
    $promptLines += ""
}

Write-Tsv (Join-Path $root "CORPUS.tsv") $corpusRows @("id", "level", "topic", "aru", "en", "notes")
Write-Tsv (Join-Path $root "DIALOGUES.tsv") $dialogueRows @("id", "level", "topic", "aru", "en", "notes")
Set-Content -Path (Join-Path $root "PROMPTS.md") -Value $promptLines -Encoding utf8

Write-Output "Generated CORPUS.tsv: $($corpusRows.Count) texts"
Write-Output "Generated DIALOGUES.tsv: $($dialogueRows.Count) dialogues"
Write-Output "Generated PROMPTS.md: $($prompts.Count) prompts"
