# Aru

**Aru** is a minimalist language of economical clarity.

Its goal is to be small, regular, and useful for simple speech without grammatical gender, cases, conjugations, agreement, obligatory number, obligatory tense, or irregular forms.

Current status: **stable core v1.0.0**.

Current project release: **v1.12.0**.

## Core Idea

```text
small lexicon + regular particles + short phrases = clear minimalism
```

Aru removes heavy grammatical categories, but keeps a small set of required particles:

```text
ra        predicate boundary
ke        direct object
ne        weak relation
le        context frame
re ... ri relative phrase
```

## Quick Examples

```text
na ra waro.
I speak.
```

```text
na ra sela ke luma.
I see light / the sun.
```

```text
etu ta ra naka le, na ra naka.
If you go, I go.
```

```text
na ra sona ke i le, u ra pa tanu.
I know that they came.
```

```text
mene re ri ra waro, ra nela.
The person who speaks is good.
```

## Repository Structure

```text
SPEC.md        canonical grammar and design decisions
LEXICON.tsv    core vocabulary with stable IDs
LEXICON_POLICY.md lexicon lifecycle and proposal rules
PHRASEBOOK.tsv 150 example phrases
CORPUS.tsv     100 levelled short corpus texts
DIALOGUES.tsv  30 levelled learning dialogues
COURSE.md      12-lesson learner course
REFERENCE.md   compact grammar reference
FLASHCARDS.tsv generated study cards
RELEASES.tsv   project release timeline
GOVERNANCE.md  project decision process
STYLE_GUIDE.md public Aru writing style
REVIEW_CHECKLIST.md reviewer checklist
AUTHORING.md   writing and editor workflow
TEXT_WORKFLOW.md text submission workflow
TEXT_SUBMISSIONS.tsv queued public text drafts
BENCHMARK.md  translation benchmark guide
QUALITY_METRICS.md scoring guide for public examples
TRANSLATION_BENCH.tsv 50 translation benchmark items
PROMPTS.md     20 writing prompts
EXAMPLES.md    lessons, corpus, dialogues, and smoke phrases
LICENSE.md     project license
CHANGELOG.md   release history
CONTRIBUTING.md contribution rules and roadmap
index.html     public website and browser playground
tools/         project checks
.github/       contribution and discussion templates
```

## License

The project is licensed under the custom **Aru License 1.0**.

Using Aru as a language is free: you may speak, write, teach, translate, publish, and create works in Aru without permission, fee, or attribution requirement.

See [LICENSE.md](LICENSE.md).

Start with [SPEC.md](SPEC.md).

Open [index.html](index.html) for the public site and browser playground.

## Release Check

```powershell
.\tools\check-release.ps1
```

```powershell
.\tools\aru-tool.ps1 -Text "na ra waro."
.\tools\aru-tool.ps1 -Search waro
.\tools\aru-tool.ps1 -Search house -Phrases
.\tools\aru-tool.ps1 -Search community -Corpus
.\tools\aru-tool.ps1 -Search meeting -Dialogues
.\tools\aru-tool.ps1 -Search waro -Cards
.\tools\aru-tool.ps1 -Search relative -Benchmark
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
.\tools\serve-site.ps1
.\tools\benchmark-report.ps1
.\tools\project-report.ps1
```

## Publishing Checklist

- Configure Git identity if needed: `user.name` and `user.email`.
- Create the first commit.
- Tag releases as needed.
- Push the repository.
- Optionally enable GitHub Pages from the `main` branch and repository root.

## Main Rule

```text
Better two clear short phrases than one long unclear phrase.
```
