# Aru Governance

Aru has a stable language core and a growing public project around it.

The language core is **Aru v1.0.0**. Project releases may add texts, tools, lessons, metadata, checks, and community process without breaking existing v1.0.0 examples.

## Decision Principles

- Preserve compatibility before adding novelty.
- Prefer real usage problems over speculative grammar.
- Prefer short examples over abstract claims.
- Prefer existing roots and compounds before accepting new roots.
- Keep public examples valid against automated checks.

## Change Classes

### Patch

Patch changes fix typos, wording, formatting, translations, metadata, or checks without changing Aru behavior.

### Minor

Minor changes add compatible roots, examples, corpus texts, lessons, tooling, website features, or project process.

### Major

Major changes break existing grammar, change stable particles, remove core roots, or make existing valid v1.0.0 examples invalid.

Major changes require a grammar RFC and a migration note.

## Decision Flow

```text
need -> examples -> alternatives -> proposal -> review -> checks -> release
```

For grammar changes:

```text
problem -> attempted Aru expressions -> proposed rule -> examples -> compatibility note
```

For new roots:

```text
root -> meaning -> domain -> level -> examples -> need -> alternatives tried
```

## Review Rules

Every accepted change should answer:

- Does it preserve Aru v1.0.0 compatibility?
- Does it keep examples short and readable?
- Does it pass `tools/check-release.ps1`?
- Does it improve a real user path: learning, reading, writing, tooling, or contribution?

## Release Ownership

Project releases should update:

- `CHANGELOG.md`
- `RELEASES.tsv`
- `README.md`
- relevant checks under `tools/`

Language-core changes should also update:

- `SPEC.md`
- `LEXICON.tsv` when roots are affected
- examples and corpus where behavior changes

## Stability Promise

Existing Aru v1.0.0 examples should remain understandable and valid unless a future major version explicitly documents a breaking change.
