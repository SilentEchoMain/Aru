# Aru Style Guide

This guide keeps public Aru texts readable.

The language core is **Aru v1.0.0**. Style guidance can improve, but it should not change grammar.

## Core Style

Write short sentences.

Prefer:

```text
mene ra lowa ke sipu.
mene ra sona ke naru.
```

Avoid packing too much into one sentence.

## Sentence Length

Public learning examples should usually use one to twelve Aru tokens.

Corpus texts can use longer sentences when they demonstrate:

- `ke i le`
- `re ... ri`
- `pasu`
- context with `le`
- cause with `so etu`

## Relative Phrases

Keep `re ... ri` phrases short.

Prefer:

```text
mene re ri ra raku ke sipu, ra nela.
```

For heavier ideas, split into two sentences:

```text
mene ra raku ke sipu.
mene i ra nela.
```

## Names

Mark names and foreign words with `ya`.

```text
lani ne na ra ya Mira.
na ra nema ke ya Aru.
```

## Levels

Use levels as a writing target:

```text
A0  first-contact examples
A1  everyday examples
A2  structured examples
B1  future extended examples
```

A0 texts should avoid relative clauses and comparison.

A1 texts can use time, relations, commands, negation, and content clauses.

A2 texts can use relative phrases, comparison, and denser context framing.

## Translation

English translations should be natural but close enough to show the Aru structure.

Do not add information to the translation that is not present in the Aru text unless the note explains it.

## Public Examples

Before publishing examples, run:

```powershell
.\tools\check-grammar.ps1
.\tools\check-release.ps1
```
