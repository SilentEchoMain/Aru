# Aru Grammar Conformance

This document defines the first machine-checkable conformance layer for **Aru v1.0.0**.

It does not replace `SPEC.md`. It turns common v1.0.0 sentence patterns into parser targets and regression tests.

## Parser Scope

The v1.14.0 parser checks:

- known core roots from `LEXICON.tsv`;
- names after `ya`;
- exact digits after `saka`;
- declarative clauses with `ra`;
- yes/no questions with initial `ka`;
- unknown-element questions with `se`;
- imperatives with `o`;
- direct objects with `ke`;
- context frames with `le`;
- content clauses using `ke i le`;
- relative phrases using `re` and `ri`;
- comparison with `pasu`;
- common terminal boundary errors.

The parser is intentionally conservative. It is a release gate and teaching aid, not a full natural-language interpreter.

## Conformance Data

`CONFORMANCE.tsv` stores positive and negative grammar examples.

Columns:

```text
id             stable conformance ID
expected       valid | invalid
level          A0 | A1 | A2
feature        main feature being tested
text           Aru sentence or short statement
expected_kind  declarative | imperative | yesno_question | unknown_question | invalid
notes          review note
```

## Commands

Parse one sentence:

```powershell
.\tools\parse-aru.ps1 -Text "na ra sela ke luma."
```

Return JSON:

```powershell
.\tools\parse-aru.ps1 -Text "na ra sela ke luma." -Json
```

Run the conformance suite:

```powershell
.\tools\check-conformance.ps1
.\tools\conformance-report.ps1
```

## Compatibility Rule

A v1.0.0 public example should not be removed from the valid conformance set unless the example itself is corrected and the compatibility note is clear.

Invalid conformance examples should stay invalid unless a deliberate future grammar release changes the rule.
