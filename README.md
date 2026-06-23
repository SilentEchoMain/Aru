# Aru

**Aru** is a minimalist language of economical clarity.

Its goal is to be small, regular, and useful for simple speech without grammatical gender, cases, conjugations, agreement, obligatory number, obligatory tense, or irregular forms.

Current status: **stable core v1.0.0**.

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
LEXICON.tsv    core vocabulary
PHRASEBOOK.tsv 100 example phrases
EXAMPLES.md    lessons, corpus, dialogues, and smoke phrases
LICENSE.md     project license
CHANGELOG.md   release history
CONTRIBUTING.md contribution rules and roadmap
tools/         project checks
```

## License

The project is licensed under the custom **Aru License 1.0**.

Using Aru as a language is free: you may speak, write, teach, translate, publish, and create works in Aru without permission, fee, or attribution requirement.

See [LICENSE.md](LICENSE.md).

Start with [SPEC.md](SPEC.md).

## Release Check

```powershell
.\tools\check-release.ps1
```

## Publishing Checklist

- Configure Git identity if needed: `user.name` and `user.email`.
- Create the first commit.
- Tag the release as `v1.0.0`.
- Push the repository.
- Optionally enable GitHub Pages from the main branch.

## Main Rule

```text
Better two clear short phrases than one long unclear phrase.
```
