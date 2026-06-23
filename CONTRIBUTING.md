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

## Growth Model

Aru should grow through usage, not speculation.

The core loop:

```text
clear idea -> easy entry -> real texts -> tools -> people -> feedback -> better texts
```

The project should optimize for one experience:

```text
I understood the basics quickly, and I can say something real.
```

## Post-1.0 Priorities

- Write more original texts in Aru.
- Keep expanding the phrasebook and corpus.
- Add optional domain vocabularies outside the core lexicon.
- Build a parser or validator from the formal grammar sketch.
- Keep improving the public site and playground.
- Add syntax highlighting for editors.
- Publish writing prompts and translation challenges.
- Invite feedback through GitHub Issues and Discussions.
- Use real phrasing problems as the source of future language changes.

## Community Process

New examples can be added freely when they follow the v1.0.0 grammar.

New roots should be proposed with:

```text
root -> meaning -> example phrase -> reason
```

New grammar should be proposed only after existing grammar fails to express a repeated need across real texts.

Grammar proposals should include:

```text
problem -> attempted Aru expressions -> proposed rule -> examples -> compatibility note
```

## Not In v1.0.0

- Native exact numeral system.
- Poetry or literary style rules.
- Full parser implementation.
- Dialects or alternative word orders.
- Large scientific or technical vocabulary.

These can be added later without changing the stable core.
