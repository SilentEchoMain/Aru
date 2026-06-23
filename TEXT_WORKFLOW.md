# Aru Text Workflow

This workflow explains how new public Aru text moves from draft to corpus, phrasebook, dialogue, or prompt material.

The language core is **Aru v1.0.0**. Text workflow should expand usage without breaking the core.

## Queue File

`TEXT_SUBMISSIONS.tsv` is the public queue for proposed texts.

Columns:

```text
id      stable queue ID
type    phrase | corpus | dialogue | prompt
level   A0 | A1 | A2 | B1
topic   short lowercase topic
aru     Aru text
en      close English translation
notes   review note or intended use
status  draft | review | accepted | rejected
```

## Status Flow

```text
draft -> review -> accepted
draft -> review -> rejected
```

Accepted texts can be copied into:

- `PHRASEBOOK.tsv`
- `CORPUS.tsv`
- `DIALOGUES.tsv`
- `PROMPTS.md`

The queue keeps the proposal history.

## Create A Draft Row

Use:

```powershell
.\tools\new-text-submission.ps1 -Type corpus -Level A1 -Topic learning -Aru "na ra nema ke ya Aru." -En "I study Aru." -Notes "Short learning example"
```

Append directly to the queue:

```powershell
.\tools\new-text-submission.ps1 -Type corpus -Level A1 -Topic learning -Aru "na ra nema ke ya Aru." -En "I study Aru." -Notes "Short learning example" -Append
```

## Review

Before accepting a text:

```powershell
.\tools\check-authoring.ps1
.\tools\check-grammar.ps1
.\tools\check-release.ps1
```

Reviewers should check:

- the level matches the grammar used;
- the English is close to the Aru;
- the text solves a real learner, corpus, or translation need;
- new roots are handled through `LEXICON_POLICY.md`.
