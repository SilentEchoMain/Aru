# Aru v1.0.0 Specification

**Aru** is a minimalist language of economical clarity.

This document is the canonical grammar for **Aru v1.0.0**.

## 1. Design Goal

Aru is built for short, regular, understandable speech.

It avoids:

- grammatical gender;
- cases;
- conjugations;
- agreement;
- obligatory number;
- obligatory tense;
- irregular forms.

It keeps a small set of particles:

```text
ra   predicate boundary
ke   direct object
ne   weak relation
le   context frame
re   relative phrase
ri   relative substitute
no   negation
ka   yes/no question
o    imperative
ya   name / foreign word
```

The main style rule is:

```text
Better two clear short phrases than one long unclear phrase.
```

## 2. Phonology

Vowels:

```text
a e i o u
```

Consonants:

```text
p t k m n s l r w y
```

Allowed syllables:

```text
V
VN
CV
CVN
```

The only final consonant is `n`.

Default stress falls on the first syllable:

```text
MA-lo
SO-na
WA-ki
PA-wa
MI-so
```

Proper names after `ya` may keep foreign spelling in writing.

## 3. Roots and Roles

A root has no fixed part of speech by itself. Its grammatical role is positional.

```text
after ra             -> predicate
after ke             -> object
after another root   -> modifier
after ne             -> linked group
after re             -> relative phrase
```

Example:

```text
waro
speech / speak / speech-related
```

```text
mene waro
speaking person
```

```text
mene ra waro.
The person speaks.
```

## 4. Basic Sentence

Main structure:

```text
subject ra predicate
```

With object:

```text
subject ra predicate ke object
```

Examples:

```text
na ra waro.
I speak.
```

```text
na ra sela ke luma.
I see light / the sun.
```

```text
mene ra maku ke malo.
The person builds a house.
```

```text
malo ra maru.
The house is big.
```

`ra` does not mean "to be". It marks the boundary between topic and assertion.

## 5. Pronouns and Number

Pronouns:

```text
na -> I / we
ta -> you
u  -> he / she / it / they
```

Number is optional. If plurality matters, use `mun`.

```text
na mun   -> we
ta mun   -> you all
u mun    -> they
mene mun -> people
```

Other quantities:

```text
nalo -> zero / absence
un   -> one
san  -> two
mun  -> many
ora  -> all / every
saka -> exact number
```

Exact numbers use external digits in v1.0.0:

```text
mene saka 3
three people
```

## 6. Time

Time particles stand after `ra`.

```text
pa -> past
nu -> now / present
po -> future
```

```text
na ra pa kani ke pani.
I ate food.
```

```text
na ra nu kani ke pani.
I am eating food.
```

```text
na ra po kani ke pani.
I will eat food.
```

If time is clear from context, omit it.

```text
na ra kani ke pani.
I eat / ate / will eat food.
```

Day expressions:

```text
temu luma pa -> yesterday / previous day
temu luma nu -> today / this day
temu luma po -> tomorrow / future day
```

```text
temu luma po le, na ra po tanu.
Tomorrow I will come.
```

## 7. Negation

`no` stands before what it negates.

```text
na ra no kani ke pani.
I do not eat food.
```

```text
no na ra kani ke pani.
Not I eat food.
```

```text
na ra kani ke no pani.
I eat not-food.
```

Default event negation with tense:

```text
subject ra tense no predicate
```

```text
na ra pa no tanu.
I did not come.
```

## 8. Imperative

Imperative structure:

```text
[addressee] o [predicate] [ke object]
```

```text
o naka.
Go.
```

```text
o kani ke pani.
Eat food.
```

```text
ta o kani ke pani.
You, eat food.
```

```text
o no naka.
Do not go.
```

## 9. Noun Groups

The head comes first. Modifiers follow.

```text
mene nela
good person
```

```text
malo maru
big house
```

```text
pani welo
hot food
```

Sequential modifiers apply left to right.

```text
tulu sela para
distant seeing-tool
```

For "tool of distant seeing", use `ne`.

```text
tulu ne sela para
tool of distant seeing
```

## 10. Weak Relation: `ne`

`ne` marks a weak, classificational, or possessive relation.

```text
X ne Y = X related to Y
```

```text
malo ne na
my house
```

```text
naru ne waro
rule of speech / grammar
```

Use `ne` only when the exact relation is not important. If the relation matters, use `to`, `ko`, `so`, or `we`.

```text
malo to wai
house by / at the water
```

```text
malo ko wai
house for water
```

```text
malo so wai
house from water / made from water
```

```text
malo we wai
house with water
```

The phrase after `ne` continues until a strong boundary:

```text
ra ke le re an alo sia tune pasu pause end
```

```text
malo ne tulu ne sela para
malo ne [tulu ne [sela para]]
```

## 11. Relations

```text
to -> area / place / contact
ko -> direction / addressee / goal
so -> source
we -> accompaniment / means
```

Relation words may act as predicates after `ra`.

```text
na ra to malo.
I am at the house.
```

```text
na ra naka ko malo.
I go to the house.
```

```text
na ra naka so malo.
I go from the house.
```

```text
na ra maku ke malo we tulu.
I build a house with a tool.
```

`so` means physical source by default.

Cause:

```text
so etu X
because of X
```

```text
na ra no naka so etu nilo.
I do not go because of cold.
```

Clausal cause:

```text
so etu i le, sentence
because sentence
```

```text
na ra no naka so etu i le, u ra nilo.
I do not go because it is cold.
```

Cause question:

```text
ta ra no tanu so etu se?
Why did you not come?
```

## 12. Context: `le`

`le` separates a frame from the main sentence.

```text
X le, Y
in the context of X, Y is true
```

Time:

```text
temu luma nu le, na ra waro we ta.
Today I speak with you.
```

Condition:

```text
etu ta ra naka le, na ra naka.
If you go, I go.
```

Topic:

```text
malo ne na le, ta ra naka ko i.
As for my house, you go to it.
```

## 13. Content Clauses: `ke i le`

`ke i le` introduces content.

```text
na ra waro ke i le, u ra pa tanu.
I say that they came.
```

```text
na ra sona ke i le, u ra pa tanu.
I know that they came.
```

```text
ta ra rima ke i le, na ra naka.
You want me to go.
```

Aru does not strictly distinguish "that", "so that", "the fact that", and "content of speech". Context decides.

## 14. Relative Phrases: `re` and `ri`

`re` introduces a relative phrase.

`ri` is used only inside `re` and points back to the head.

Subject:

```text
mene re ri ra maku ke malo
person who builds a house
```

Object:

```text
malo re na ra sela ke ri
house that I see
```

Place:

```text
malo re na ra to ri
house where I am
```

Addressee:

```text
mene re na ra lano ke pani ko ri
person to whom I give food
```

In precise writing, place a comma after a long `re` phrase.

```text
mene re ri ra maku ke malo, ra nela.
The person who builds a house is good.
```

Inside `re`:

```text
ri    = the head word
i/ena = external this / that
```

## 15. Comparison

`pasu` means "than / compared with".

More:

```text
X ra Q pasu Y
```

```text
malo i ra maru pasu malo ena.
This house is bigger than that house.
```

Equal:

```text
X ra Q sama pasu Y
```

```text
malo i ra maru sama pasu malo ena.
This house is as big as that one.
```

Less:

```text
X ra Q mini pasu Y
```

```text
malo i ra maru mini pasu malo ena.
This house is less big than that one.
```

Superlative:

```text
X ra Q pasu ora
```

```text
malo i ra maru pasu ora.
This house is the biggest.
```

Degree without comparison:

```text
Q maru -> very Q
Q mini -> slightly Q
```

```text
wai ra welo maru.
The water is very hot.
```

## 16. Action Chains

Action chains may start with modal and phase roots:

```text
rima -> want / intend
pawa -> can / have power
sona -> know / understand / know how
sima -> need / should
waki -> begin
ruma -> become
pini -> finish / stop
```

```text
na ra rima kani.
I want to eat.
```

```text
na ra pawa naka.
I can go.
```

```text
na ra sona maku ke malo.
I know how to build a house.
```

```text
na ra ruma mene nela.
I become a good person.
```

`rima X` is an action chain. `rima ke X` means wanting an object or content.

```text
na ra rima ke wai.
I want water.
```

```text
na ra rima ke i le, ta ra tanu.
I want you to come.
```

## 17. Questions

`ka` marks a yes/no question.

```text
ka ta ra kani?
Are you eating?
```

`se` marks an unknown element.

```text
se ra naka?
Who is going?
```

```text
ta ra sela ke se?
What do you see?
```

```text
mene se?
What kind of person?
```

```text
ta ra to se?
Where are you?
```

Questions with `se` do not require `ka`, but require question intonation or a question mark.

In statements, `se` means an indefinite element.

```text
mene se ra naka.
Someone is going.
```

## 18. Names: `ya`

`ya` marks a proper name or foreign word.

```text
lani ne na ra ya Aru.
My name is Aru.
```

```text
na ra waro we ya Mira.
I speak with Mira.
```

The name continues until a pause, punctuation, end of sentence, or explicit service boundary.

```text
na ra sela ke ya New York, ko ta.
I show New York to you.
```

## 19. Conjunctions

```text
an   -> and
alo  -> or
sia  -> therefore
tune -> but
```

`an` and `alo` connect the nearest same-type groups.

```text
na an ta ra kani.
I and you eat.
```

```text
pani an wai
food and water
```

For full sentences, repeat the structure.

```text
na ra kani, an ta ra waro.
I eat, and you speak.
```

`sia` and `tune` connect full utterances and require a pause before them.

```text
u ra nilo, sia na ra no naka.
It is cold, therefore I do not go.
```

## 20. Style

Aru allows complex phrases, but prefers short clear statements.

Less preferred:

```text
mene re ri ra sona ke i le, u ra pa tanu, ra nela.
```

Preferred:

```text
mene ra sona ke i le, u ra pa tanu.
mene i ra nela.
```

Main rule:

```text
Use the smallest structure that keeps the meaning clear.
```

## 21. Release Criteria

Aru v1.0.0 is a stable core, not a complete world language.

The v1.0.0 release is stable because:

- the core particles are defined: `ra`, `ke`, `ne`, `le`, `re`, `ri`, `no`, `ka`, `o`, `ya`;
- predicate, object, context, relation, question, command, comparison, and relative constructions are documented;
- the main open design questions have explicit decisions;
- the core lexicon is large enough for ordinary examples;
- the corpus contains examples, dialogues, texts, and a phrasebook;
- smoke phrases have official translations;
- future breaking changes require a new major version.

Texts valid under v1.0.0 should remain understandable in later 1.x versions.

## 22. Design Decisions

### `rima` With Actions and Objects

Both forms are valid, but they mean different things.

```text
na ra rima naka.
I want to go.
```

```text
na ra rima ke wai.
I want water.
```

`rima X` is an action chain. `rima ke X` takes a desired object or content.

### Cause and "Why"

Aru does not add a separate "because" particle in v1.0.0.

```text
na ra no naka so etu nilo.
I do not go because of cold.
```

```text
na ra no naka so etu i le, u ra nilo.
I do not go because it is cold.
```

```text
ta ra no tanu so etu se?
Why did you not come?
```

### Relation Words as Predicates

`to`, `ko`, `so`, `we`, and `ne` may appear after `ra`.

```text
na ra to malo.
I am at the house.
```

```text
na ra we ta.
I am with you.
```

### Name Boundaries

`ya` marks the start of a name. In writing, a comma closes a long or potentially ambiguous name before another service particle.

```text
na ra sela ke ya New York, ko ta.
I show New York to you.
```

### Exact Numbers

v1.0.0 uses external digits after `saka`.

```text
mene saka 3
three people
```

Native exact numerals may be added later as an optional module.

## 23. Versioning

Aru uses specification versioning:

```text
MAJOR.MINOR.PATCH
```

- `MAJOR`: breaking grammar changes.
- `MINOR`: compatible language growth.
- `PATCH`: text and documentation fixes.

The current version is:

```text
v1.0.0
```

## 24. Formal Grammar Sketch

This sketch is a compact reference for future tooling. It is not a full parser implementation.

```ebnf
text            = { utterance } ;
utterance       = sentence, [ "." | "?" ] ;

sentence        = yes_no_question
                | imperative
                | framed_sentence
                | clause ;

yes_no_question = "ka", clause ;

imperative      = [ noun_phrase ], "o", predicate_phrase ;

framed_sentence = frame, "le", ",", clause ;
frame           = phrase ;

clause          = noun_phrase, "ra", predicate_phrase ;

predicate_phrase = [ tense ], [ negation ], predicate, { complement } ;
predicate       = phrase
                | relation_phrase ;

tense           = "pa" | "nu" | "po" ;
negation        = "no" ;

complement      = object_phrase
                | relation_phrase
                | comparison_phrase
                | content_clause ;

object_phrase   = "ke", phrase ;
content_clause  = "ke", "i", "le", ",", clause ;

relation_phrase = relation, phrase
                | "so", "etu", phrase
                | "so", "etu", "i", "le", ",", clause ;
relation        = "to" | "ko" | "so" | "we" | "ne" ;

comparison_phrase = "pasu", phrase
                  | "sama", "pasu", phrase
                  | "mini", "pasu", phrase ;

noun_phrase     = phrase ;
phrase          = term, { term | weak_relation | relative_phrase | conjunction } ;
term            = root
                | pronoun
                | demonstrative
                | quantity
                | unknown
                | name ;

weak_relation   = "ne", phrase ;
relative_phrase = "re", clause_with_ri ;
clause_with_ri  = { token_with_ri } ;

conjunction     = ("an" | "alo"), phrase ;

pronoun         = "na" | "ta" | "u" ;
demonstrative   = "i" | "ena" ;
quantity        = "nalo" | "un" | "san" | "mun" | "ora" | exact_number ;
exact_number    = "saka", digit, { digit } ;
unknown         = "se" ;
name            = "ya", name_token, { name_token } ;

root            = syllable, { syllable } ;
syllable        = vowel
                | vowel, "n"
                | consonant, vowel
                | consonant, vowel, "n" ;

vowel           = "a" | "e" | "i" | "o" | "u" ;
consonant       = "p" | "t" | "k" | "m" | "n" | "s" | "l" | "r" | "w" | "y" ;
digit           = "0" | "1" | "2" | "3" | "4" | "5" | "6" | "7" | "8" | "9" ;

token_with_ri   = ? any Aru token in a relative phrase, including ri ? ;
name_token      = ? any written name token until pause, punctuation, or service boundary ? ;
```
