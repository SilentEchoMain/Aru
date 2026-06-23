# Contributing

Aru v1.0.0 is a stable core. Contributions should protect clarity and compatibility.

## Principles

- Prefer short examples over abstract explanation.
- Add new grammar only when the corpus needs it.
- Add specialized vocabulary outside the core unless it is broadly useful.
- Keep existing v1.0.0 examples understandable.

## Change Format

For language changes, record:

```text
problem -> decision -> examples -> compatibility note
```

Use [SPEC.md](SPEC.md) as the model.

## Versioning

- Patch: typos, wording, translation fixes.
- Minor: compatible roots, examples, lessons, tooling.
- Major: breaking grammar changes.

## Roadmap

The stable core is frozen at **Aru v1.0.0**. Future work should expand use without breaking existing v1.0.0 texts.

Post-1.0 priorities:

- Write more original texts in Aru.
- Keep expanding the phrasebook and corpus.
- Add optional domain vocabularies outside the core lexicon.
- Build a parser or validator from the formal grammar sketch.
- Make a GitHub Pages site from the docs.
- Add syntax highlighting for editors.

Not in v1.0.0:

- Native exact numeral system.
- Poetry or literary style rules.
- Full parser implementation.
- Dialects or alternative word orders.
- Large scientific or technical vocabulary.

These can be added later without changing the stable core.
