# Aru Review Checklist

Use this checklist when reviewing pull requests, issue proposals, and discussion contributions.

## Compatibility

- Existing Aru v1.0.0 examples remain valid.
- New examples use only core roots, names after `ya`, or digits after `saka`.
- Any breaking change is marked as major and has a migration note.

## Language Quality

- Sentences are short enough for the intended level.
- `ra`, `ke`, `le`, `re`, and `ri` are used consistently.
- `ri` appears only inside a `re` phrase.
- Names are marked with `ya`.
- Exact numbers use `saka`.

## Lexicon

- New roots follow `LEXICON_POLICY.md`.
- Existing roots and compounds were tried before proposing a new root.
- New roots have domain, level, status, and introduced metadata.
- Root IDs are stable and not reused.

## Corpus And Lessons

- Corpus entries have level metadata.
- Dialogues are short and useful for learners.
- Lessons introduce patterns before dense examples.
- Translations are clear and do not hide missing Aru structure.
- Benchmark rows are short, levelled, and tied to one main phenomenon.
- Benchmark reference translations follow `QUALITY_METRICS.md`.

## Editor And Authoring

- Public authoring guidance stays aligned with `STYLE_GUIDE.md`.
- Editor snippets use valid Aru examples.
- Editor grammar highlights core particles, relations, names, and numbers.
- Text submissions use `TEXT_SUBMISSIONS.tsv` schema and `TEXT_WORKFLOW.md` status flow.

## Project Checks

Run:

```powershell
.\tools\build-corpus.ps1
.\tools\build-learning.ps1
.\tools\build-releases.ps1
.\tools\check-authoring.ps1
.\tools\check-benchmark.ps1
.\tools\check-community.ps1
.\tools\check-editor.ps1
.\tools\check-lexicon.ps1
.\tools\check-grammar.ps1
.\tools\check-portal.ps1
.\tools\test-site.ps1
.\tools\check-release.ps1
```

## Release Notes

- `CHANGELOG.md` describes user-visible changes.
- `RELEASES.tsv` identifies the current release.
- `README.md` shows the current project release.
- The language core remains explicit when unchanged.
