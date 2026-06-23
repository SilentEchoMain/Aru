# Aru Lexicon Policy

Aru keeps a small core lexicon. New roots are accepted only when real texts need them and existing roots or compounds do not express the need clearly.

The language core remains **Aru v1.0.0**. This policy governs project-level lexicon maintenance.

## Lexicon Columns

`LEXICON.tsv` uses these columns:

```text
id          stable root identifier
root        Aru root
category    grammar or lexical category
domain      broad semantic or functional domain
level       learner level where the root should first appear
status      root lifecycle status
introduced  release where the root entered the project
meaning     compact English meaning
notes       usage note
```

## Stable IDs

IDs use this format:

```text
ARU-001
ARU-002
ARU-003
```

Rules:

- Never reuse an ID for a different root.
- Do not renumber existing roots.
- New accepted roots receive the next unused ID.
- Deprecated roots keep their ID and receive `status = deprecated`.

## Status Values

```text
core        stable v1.0.0 root
candidate   proposed compatible root
deprecated  retained for history, not recommended
```

The current public lexicon is all `core`.

## Domains

Allowed domains:

```text
grammar
society
world
body
action
quality
media
nature
abstract
```

Domains are broad search and learning labels, not grammatical classes.

## Levels

Allowed levels:

```text
A0  first-contact roots
A1  everyday roots
A2  structured-text roots
B1  future extended roots
```

Levels guide lessons, flashcards, and corpus search. They do not change grammar.

## Accepting New Roots

A root proposal should include:

```text
root -> meaning -> domain -> level -> examples -> need -> alternatives tried
```

Acceptance criteria:

- The root follows Aru phonology.
- The meaning is broad enough to reuse.
- The need appears in real examples, corpus work, or repeated learner requests.
- Existing roots, compounds, or `ne` phrases were tried first.
- The root does not create a near-duplicate of an existing core root.

Before accepting a root, run:

```powershell
.\tools\check-lexicon.ps1
.\tools\check-grammar.ps1
.\tools\check-release.ps1
```
