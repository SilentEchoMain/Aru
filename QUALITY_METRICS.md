# Aru Quality Metrics

These metrics help reviewers score Aru translations, corpus texts, lessons, and public examples.

Scores are meant for review discussion. They do not change the stable language core.

## Translation Score

Use a 0 to 3 score for each dimension.

```text
3 = strong
2 = usable with minor issues
1 = understandable but needs revision
0 = wrong or unclear
```

## Dimensions

### Meaning

Does the Aru text preserve the source meaning without adding or removing important information?

### Grammar

Does the text follow the v1.0.0 grammar, including particles, word order, and relative or context boundaries?

### Lexicon

Does the text use accepted roots and avoid unnecessary new roots?

### Clarity

Would a learner understand the sentence without hidden assumptions?

### Economy

Does the text prefer short, clear sentences over avoidable nesting?

## Minimum Bar

Public examples should normally score at least:

```text
Meaning 2
Grammar 3
Lexicon 3
Clarity 2
Economy 2
```

Benchmark reference translations should normally score 3 in every dimension.

## Reviewer Notes

When a score is below 3, write a short note:

- what changed in meaning;
- which rule was involved;
- whether the fix needs grammar, wording, or lexicon work;
- whether the issue belongs in `TEXT_SUBMISSIONS.tsv` or a GitHub issue.
