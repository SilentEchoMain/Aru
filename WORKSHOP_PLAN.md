# Aru 60-Minute Workshop

This plan is for a first public Aru session.

## Outcomes

By the end, participants should be able to:

- read a simple Aru sentence;
- write a simple Aru sentence;
- ask one yes/no or `se` question;
- submit or review one short draft.

## Schedule

### 0-5: Entry

Show:

```text
na ra waro.
```

Explain that `ra` is the predicate boundary.

### 5-15: Basic Sentences

Use:

```text
mene ra waro.
na ra sela ke luma.
ta ra kani ke pani?
```

Participants write one sentence about seeing, eating, or speaking.

### 15-25: Relations

Use:

```text
na ra naka ko malo.
na ra to insa malo.
na ra naka so malo.
```

Participants change the relation and explain the meaning.

### 25-35: Context

Use:

```text
temu luma nu le, na ra waro.
etu ta ra naka le, na ra naka.
```

Participants write one time frame or condition.

### 35-45: Review

Use `QUALITY_METRICS.md` with one short translation.

Score meaning, grammar, lexicon, clarity, and economy.

### 45-55: Challenge

Pick two rows from `COMMUNITY_CHALLENGES.tsv`.

Participants complete one reading task and one writing or translation task.

### 55-60: Next Step

Show how to use:

```powershell
.\tools\aru-tool.ps1 -Text "na ra waro."
.\tools\new-text-submission.ps1 -Type corpus -Level A0 -Topic first-text -Aru "na ra waro." -En "I speak." -Notes "Workshop draft"
```
