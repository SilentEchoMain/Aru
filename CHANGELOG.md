# Changelog

## Aru Project v1.7.0

- Added `RELEASES.tsv` as a structured project release timeline.
- Added `tools/build-releases.ps1` to regenerate release timeline data.
- Added `tools/check-portal.ps1` to validate public portal features and release metadata.
- Upgraded `index.html` with dashboard metrics, portal filters, corpus/dialogue filters, and a release timeline.
- Extended release checks, GitHub Actions, project reports, CLI search, and site smoke checks for portal data.
- Language core remains **Aru v1.0.0**.

## Aru Project v1.6.0

- Added stable lexicon metadata columns: `id`, `domain`, `level`, `status`, and `introduced`.
- Added `LEXICON_POLICY.md` for root lifecycle, ID, domain, level, and proposal rules.
- Added `tools/check-lexicon.ps1` for lexicon schema, ID, status, domain, level, duplicate, and phonology checks.
- Extended release checks and GitHub Actions with lexicon validation.
- Extended the site, CLI, flashcards, project report, PR template, and word-proposal template with lexicon metadata.
- Language core remains **Aru v1.0.0**.

## Aru Project v1.5.0

- Added `level` metadata to `CORPUS.tsv` and `DIALOGUES.tsv`.
- Updated `tools/build-corpus.ps1` so corpus and dialogue levels are generated reproducibly.
- Updated the public site to show learner levels in corpus and dialogue tables.
- Extended release checks to validate corpus and dialogue level metadata.
- Extended project reports and CLI search to include level metadata.
- Language core remains **Aru v1.0.0**.

## Aru Project v1.4.0

- Added `tools/check-grammar.ps1` for token, name, number, relative-phrase, question, imperative, and boundary checks.
- Added `.github/workflows/release-check.yml` to run generated builds, grammar checks, site checks, and release checks on GitHub.
- Extended `tools/check-release.ps1` so the release gate includes grammar validation.
- Updated project documentation for the automated grammar-check workflow.
- Language core remains **Aru v1.0.0**.

## Aru Project v1.3.0

- Added `COURSE.md` with a structured 12-lesson course.
- Added `REFERENCE.md` as a compact grammar and writing reference.
- Added `FLASHCARDS.tsv` with generated study cards for roots and phrasebook examples.
- Added `tools/build-learning.ps1` to regenerate flashcards from project data.
- Added `tools/test-site.ps1` for website smoke checks.
- Extended `tools/aru-tool.ps1` with flashcard search.
- Extended `tools/project-report.ps1` with learning-system metrics.
- Extended `index.html` with learning-system links and flashcard search.
- Strengthened `tools/check-release.ps1` to require and validate learning artifacts.
- Language core remains **Aru v1.0.0**.

## Aru Project v1.2.0

- Added `CORPUS.tsv` with 100 short stable-core texts.
- Added `DIALOGUES.tsv` with 30 learning dialogues.
- Added `PROMPTS.md` with 20 writing prompts for corpus growth.
- Added `tools/build-corpus.ps1` to regenerate the structured corpus artifacts.
- Added `tools/project-report.ps1` to summarize project size, topics, and release metadata.
- Extended `tools/aru-tool.ps1` with corpus and dialogue search.
- Extended `index.html` with corpus and dialogue browsers.
- Strengthened `tools/check-release.ps1` to require and validate corpus, dialogues, prompts, and generated Aru tokens.
- Language core remains **Aru v1.0.0**.

## Aru Project v1.1.0

- Added `index.html` as a public website, quick-start page, searchable lexicon, searchable phrasebook, and browser playground.
- Added `tools/aru-tool.ps1` for command-line text checks and lexicon/phrasebook search.
- Expanded `PHRASEBOOK.tsv` from 100 to 150 entries, with new community, writing, tooling, public launch, and story examples.
- Strengthened `tools/check-release.ps1` with site checks, license checks, TSV schema checks, phonology checks, and phrasebook token validation.
- Expanded `CONTRIBUTING.md` with a public growth model for Aru.
- Language core remains **Aru v1.0.0**.

## Aru v1.0.0

- Promoted Aru from draft to stable core grammar.
- Added canonical specification, release criteria, and design decisions in `SPEC.md`.
- Resolved open questions for `rima ke`, cause questions, relation predicates, names, and exact numbers.
- Expanded the core lexicon.
- Added `LEXICON.tsv`, `PHRASEBOOK.tsv`, and `EXAMPLES.md`.
- Embedded the formal grammar sketch in `SPEC.md`.
- Consolidated the repository into a compact GitHub-ready layout.
- Adopted the custom Aru License 1.0.

## Aru v0.1.0

- Initial grammar draft split into repository sections.
- Added core documentation, lexicon table, mini corpus, smoke phrases, and roadmap.
