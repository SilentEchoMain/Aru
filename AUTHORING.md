# Aru Authoring Guide

This guide is for people writing public Aru examples, corpus entries, lessons, and translation challenges.

The language core is **Aru v1.0.0**. Authoring tools should protect that stability.

## Quick Workflow

1. Read `STYLE_GUIDE.md`.
2. Write short Aru sentences.
3. Check roots with `tools/aru-tool.ps1`.
4. Run grammar and release checks.
5. Submit the text with notes about level, topic, and intended learner use.

```powershell
.\tools\aru-tool.ps1 -Text "na ra waro."
.\tools\check-grammar.ps1
.\tools\check-release.ps1
```

For queued proposals, use `TEXT_SUBMISSIONS.tsv` and `TEXT_WORKFLOW.md`.

```powershell
.\tools\new-text-submission.ps1 -Type corpus -Level A1 -Topic learning -Aru "na ra nema ke ya Aru." -En "I study Aru." -Notes "Short learning example"
.\tools\check-authoring.ps1
```

## Suggested Metadata

Use this metadata for new texts:

```text
level: A0 | A1 | A2 | B1
topic: short lowercase topic
aru: short Aru text
en: close English translation
notes: why the text is useful
```

Queue rows also include:

```text
id: S001 style ID
type: phrase | corpus | dialogue | prompt
status: draft | review | accepted | rejected
```

## Level Targets

`A0` should use first-contact sentences:

```text
na ra waro.
malo ra maru.
```

`A1` can use time, relations, negation, commands, and content:

```text
temu luma nu le, na ra waro.
na ra sona ke i le, u ra pa tanu.
```

`A2` can use comparison and relative phrases:

```text
malo i ra maru pasu malo ena.
mene re ri ra raku ke sipu, ra nela.
```

## Editor Support

The repository includes starter VS Code assets:

```text
editor/vscode/aru.tmLanguage.json
editor/vscode/aru.code-snippets
editor/vscode/language-configuration.json
```

They are source assets for editor support. They are not yet packaged as a marketplace extension.

## Review

Before proposing a text, check it against:

- `TEXT_WORKFLOW.md`
- `STYLE_GUIDE.md`
- `REVIEW_CHECKLIST.md`
- `LEXICON_POLICY.md` if it needs a new root
- `GOVERNANCE.md` if it changes language behavior
