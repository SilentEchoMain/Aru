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
- Keep improving the parser and validator from the formal grammar sketch.
- Keep improving the public site and playground.
- Add syntax highlighting for editors.
- Publish writing prompts and translation challenges.
- Invite feedback through GitHub Issues and Discussions.
- Use real phrasing problems as the source of future language changes.

Current public-use targets:

- Keep at least 150 phrasebook entries.
- Keep at least 100 short corpus texts.
- Keep at least 30 learning dialogues.
- Keep at least 20 writing prompts.
- Keep at least 300 generated learning flashcards.
- Keep at least 50 translation benchmark items.
- Keep at least 30 public community challenges.
- Keep at least 60 grammar conformance rows, including invalid examples.
- Keep all public examples valid against the core lexicon unless they are marked names after `ya` or exact digits after `saka`.
- Run `.\tools\check-grammar.ps1` before proposing changes to public examples.

## Community Process

New examples can be added freely when they follow the v1.0.0 grammar.

New roots should be proposed with:

```text
root -> meaning -> domain -> level -> examples -> need -> alternatives tried
```

Use [LEXICON_POLICY.md](LEXICON_POLICY.md) for root IDs, domains, levels, and lifecycle status.

New grammar should be proposed only after existing grammar fails to express a repeated need across real texts.

Grammar proposals should include:

```text
problem -> attempted Aru expressions -> proposed rule -> examples -> compatibility note
```

Use [GOVERNANCE.md](GOVERNANCE.md), [STYLE_GUIDE.md](STYLE_GUIDE.md), [AUTHORING.md](AUTHORING.md), [ADOPTION.md](ADOPTION.md), [TEACHER_GUIDE.md](TEACHER_GUIDE.md), [WORKSHOP_PLAN.md](WORKSHOP_PLAN.md), [GRAMMAR.md](GRAMMAR.md), [BENCHMARK.md](BENCHMARK.md), [QUALITY_METRICS.md](QUALITY_METRICS.md), and [REVIEW_CHECKLIST.md](REVIEW_CHECKLIST.md) for decision rules, public writing style, authoring workflow, adoption, teaching, parser conformance, benchmark quality, scoring, and review expectations.

Before opening a pull request, run:

```powershell
.\tools\build-corpus.ps1
.\tools\build-learning.ps1
.\tools\build-releases.ps1
.\tools\check-adoption.ps1
.\tools\check-authoring.ps1
.\tools\check-benchmark.ps1
.\tools\check-conformance.ps1
.\tools\check-community.ps1
.\tools\check-editor.ps1
.\tools\check-lexicon.ps1
.\tools\check-grammar.ps1
.\tools\check-portal.ps1
.\tools\test-site.ps1
.\tools\check-release.ps1
```

## Not In v1.0.0

- Native exact numeral system.
- Poetry or literary style rules.
- Full parser implementation.
- Dialects or alternative word orders.
- Large scientific or technical vocabulary.

These can be added later without changing the stable core.
