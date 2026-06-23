# Aru Translation Benchmark

The Aru translation benchmark is a stable set of short English prompts with reference Aru translations.

The goal is not to force one literary style. The goal is to make translation quality measurable while the language core remains **Aru v1.0.0**.

## Files

- `TRANSLATION_BENCH.tsv` stores benchmark items.
- `QUALITY_METRICS.md` explains scoring.
- `tools/check-benchmark.ps1` validates the benchmark.
- `tools/benchmark-report.ps1` summarizes coverage.

## TSV Columns

```text
id             stable benchmark ID
level          A0 | A1 | A2
domain         topic area
phenomenon     main grammar or usage target
source_en      English source prompt
reference_aru  reference Aru translation
notes          review note
```

## Use

Use the benchmark to test:

- human translation consistency;
- lesson coverage;
- prompt and assistant behavior;
- vocabulary gaps;
- whether Aru stays clear under ordinary communication tasks.

## Review Rule

Benchmark rows should be short, ordinary, and checkable. A row should usually test one main feature.

If a row needs rare vocabulary, add the vocabulary through `LEXICON_POLICY.md` before adding the benchmark row.

## Commands

```powershell
.\tools\check-benchmark.ps1
.\tools\benchmark-report.ps1
.\tools\benchmark-report.ps1 -Json
```

The full release gate also runs benchmark validation:

```powershell
.\tools\check-release.ps1
```
