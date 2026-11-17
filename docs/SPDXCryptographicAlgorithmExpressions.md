# SPDX Cryptographic Algorithm List Expressions 

## Overview

Often a single cryptographic algorithm identifier can be used to represent the cryptographic profile or algorithm requirements of a system, data packet, or manifest file, but there are situations where a single algorithm identifier is not sufficient. A common example is when a system supports a choice of one or more cryptographic algorithms (e.g., `AES-256-GCM OR ChaCha20`). Another example is when a set of protocols must simultaneously require distinct algorithms to be compliant, such as demanding both a specific signature mechanism and a separate key exchange mechanism (e.g., `RSA-4096 AND ECDH-p256`).
SPDX CryptographicAlgorithm Expressions provide a way for one to construct expressions that more accurately represent complex cryptographic configurations and algorithm requirements. A cryptographic algorithm expression could be:
A single cryptographic algorithm identifier found on the SPDX CryptographicAlgorithm List (e.g., `AES`).
A single identifier paired with explicit algorithm parameters or variable parameter option sets (e.g., `AES-128-[GCM|CCM]`).
A user-defined external algorithm reference denoted by the prefix [%s"DocumentRef-" idstring ":"] %s"CryptographicAlgorithmRef-" idstring.
A combination of algorithm identifiers, parameters, and external references constructed using a small set of defined operators (e.g., AND and OR).
We provide the formal definition of what constitutes a valid SPDX CryptographicAlgorithm Expression in this section.

```abnf

idstring = 1*(ALPHA / DIGIT / "-" / "." )
ExternalCryptographicAlgorithm-ref = [%s"DocumentRef-" idstring ":"] %s"CryptographicAlgorithmRef-" idstring
CryptographicAlgorithmName = Algorithm-id / ( Algorithm-id Algorithm-Parameters ) / ExternalCryptographicAlgorithm-ref
Algorithm-id = <short-form-identifier-from-SPDX-CryptographicAlgorithm-List>
Algorithm-Parameters = *( "-" Algorithm-Parameter / "-" Algorithm-Parameter-Set / "-*") 
Algorithm-Parameter-Set = "[" Algorithm-Parameter *( "|" Algorithm-Parameter ) "]"  
Algorithm-Parameter = <The-CryptographicAlgorithm-Parameters-Value-found-in-position-of-Nth-GrammarExpressionReference-in-SPDX-CryptographicAlgorithm-List>
; Expression rules with precedence and parentheses
expression = or-expression  
or-expression = and-expression *( " OR " and-expression )
and-expression = factor *( " AND " factor )
factor = CryptographicAlgorithmName / "(" expression ")"
```

## Expression Formatting Rules

A valid <expression> string consists of either:
A simple cryptographic algorithm expression, such as a standalone algorithm identifier or parametrized identifier.
A composite expression constructed by combining smaller valid algorithm expressions using Boolean operators.

## Whitespace and Layout Constraints

There MUST be white space and/or parentheses on either side of the operators AND and OR.
In the tag:value format, a cryptographic algorithm expression MUST be on a single line, and MUST NOT include a line break in the middle of the expression.

## Case Sensitivity

### Operators

Cryptographic algorithm expression operators (AND, OR) should be matched in a case-sensitive manner. This means letters must be all upper case to be considered syntactically valid by a processing engine.

### Identifiers and Parameters

Cryptographic identifiers (including base names pulled from the SPDX CryptographicAlgorithm List) used in SPDX documents or configurations should be matched in a case-sensitive manner.

## Simple Cryptographic Algorithm Expressions

A simple cryptographic algorithm expression is composed of one of the following variations:
An SPDX CryptographicAlgorithm List Short Form Identifier. For example: AES or RSA.
An SPDX CryptographicAlgorithm List Short Form Identifier with appended parameters or parameter sets. This represents explicit constraints placed on a block cipher size, hashing digest size, or block mode. For example: AES-128 or AES-128-[GCM|CCM]. A `-*` parameter segment denotes a wildcard for a single unspecified parameter segment at the corresponding position. It indicates that any explicitly specified parameter segments are satisfied, while the parameter value at the `-*` position is unspecified. For example, `AES-[128|256]-*` denotes AES with the first AES parameter, `keyLength`, constrained to either `128` or `256`, and the next AES parameter segment, `operationMode`, left unspecified. Trailing unspecified parameter segments are considered to be wildcards.
An SPDX user-defined external cryptographic algorithm reference: [%s"DocumentRef-" idstring ":"] %s"CryptographicAlgorithmRef-" idstring.

## Structural Reference Examples

`3DES`
`AES-[128|256]-*`
`DocumentRef-ExternalSpec.2026:CryptographicAlgorithmRef-CustomCipher`
The current set of valid short-form cryptographic identifiers and their exact grammatical positions can be found in the official registry at spdx.org/cryptographic-algorithm-list.

## Composite Cryptographic Algorithm Expressions

### Introduction

More expressive composite cryptographic algorithm expressions can be constructed using OR and AND operators, which behave similarly to mapping mathematical terms via arithmetic expressions.
For the tag:value format, any cryptographic expression consisting of more than one algorithm identifier and/or external reference may optionally be encapsulated by wrapping parentheses: ( ). Nested parentheses are also explicitly used to override standard evaluation hierarchies to specify a strict order of precedence.

### Disjunctive "OR" Operator

If a system presents an alternative choice or optional fallback between two or more cryptographic algorithms, use the disjunctive binary OR operator to bind them. Both the left and right operands must resolve to valid cryptographic expression values.
Example: When a specification permits either `AES-256-GCM` or `ChaCha20`, the valid expression string is:
`AES-256-GCM` OR `ChaCha20`
Properties: The OR operator is commutative. The expression above is considered logically equivalent to:
`ChaCha20` OR `AES-256-GCM`
Chaining: Choices can be expanded across multiple criteria sequentially (e.g., `AES-128 OR AES-256 OR ChaCha20`).

### Conjunctive "AND" Operator

If a profile requires simultaneous compliance or support for two or more cryptographic primitives, use the conjunctive binary AND operator to combine them. Both the left and right operands must be valid independent cryptographic expressions.
Example: When a target architecture is forced to utilize an asymmetric signature algorithm alongside a symmetric encryption block, a valid expression string is:
`RSA-4096 AND AES-256-GCM`
Properties: The AND operator is commutative. The expression above is considered logically equivalent to:
`AES-256-GCM AND RSA-4096`
Chaining: Requirements can be chained concurrently across multiple algorithmic domains (e.g., `RSA-4096 AND ECDH-p256 AND SHA-256`). 

### Order of Precedence and Parentheses

#### Introduction

When multiple operators (AND, OR) are combined within a single cryptographic algorithm expression without parentheses, a parser must evaluate the expression according to a strict order of precedence. This ensures that the same composite expression string resolves to the exact same cryptographic requirement profile across different compliance tools and parsing engines.
The evaluation order follows standard Boolean algebra logic, prioritizing conjunctive requirements over alternative selections.

#### Order of Operations

Cryptographic algorithm expressions are evaluated in the following order of precedence, from highest priority to lowest:
Parentheses ( ): Any sub-expression enclosed in parentheses MUST be evaluated first, regardless of the operators surrounding it.
Conjunctive AND: Grouping via conjunction takes priority over disjunction.
Disjunctive OR: Alternative selection grouping has the lowest evaluation priority.
Operators with the same precedence level are evaluated from left to right.
It is best practice for readability and to prevent logical ambiguity, explicitly wrap sub-expressions in parentheses whenever AND and OR operators are mixed within the same expression. 

#### Precedence Examples and Logic Mapping

##### Case 1: Standard Evaluation Hierarchy

Consider the following expression without explicit parentheses:
`AES-256-GCM AND SHA-256` OR `ChaCha20`
Because AND has higher precedence than OR, this expression parses as if it were written with parentheses around the first two terms:
`(AES-256-GCM AND SHA-256) OR ChaCha20`
Compliance Profile Interpretation: A system is compliant if it supports both `AES-256-GCM` and `SHA-256`, OR if it supports `ChaCha20` standalone.

##### Case 2: Overriding Precedence with Parentheses

If a specification intends to require a hash function paired with either of two ciphers, parentheses must be explicitly used to override the default order of operations:
`AES-256-GCM AND (SHA-256 OR SHA-512)`
Compliance Profile Interpretation: A system must support `AES-256-GCM` in all scenarios, alongside at least one of the hashing primitives (`SHA-256` or `SHA-512`).
Writing this without parentheses (`AES-256-GCM AND SHA-256 OR SHA-512`) would change the meaning entirely, misinterpreting it as matching either the AES-256-GCM AND SHA-256 pair, or SHA-512 by itself.

##### Strict Nesting Constraints

Spaces MUST separate outer operators from parentheses boundaries. For example, `AES-128 AND(SHA-256 OR SHA-512)` is syntactically invalid. It must be written as `AES-128 AND (SHA-256 OR SHA-512)`.
Redundant nesting (e.g., `((AES-256-GCM)) or (RSA))` is syntactically valid but discouraged for readability.

