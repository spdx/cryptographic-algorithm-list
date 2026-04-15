# Contributing to SPDX Cryptographic Algorithm List

* General technical questions or issues about the List can be sent to the SPDX technical team mailing list.
* Questions or issues on any algorithm content can be reported through a [GitHub issue](https://github.com/spdx/cryptographic-algorithm-list/issues):
   * Review first that your question or issue has not been reported already. If it has been, simple add a comment in the corresponding issue
   * If there is no past record of your question or issue, please create a new issue
* You are welcome to participate in any of the SPDX Cryptography Group weekly meetings. Check the [SPDX meetings list](https://github.com/spdx/meetings?tab=readme-ov-file#cryptography) to find out the schedule and connection details
   * The agenda for the next meeting can be found in [this folder](https://hackmd.io/folders/oLPOEiStpNeFUH87rwJkm?nav=overview) while the approved minutes are merged into the [cryptography meeting folder](https://github.com/spdx/meetings/tree/main/cryptography) in bulks

## Algorithm example

This is an example of how an algorithm from the SPDX Cryptographic Algorithm List is described. This example correspond to no real algorithm.

---
```
# SPDX-License-Identifier: CC0-1.0
id: scale
oid: 1.5.21.171.3.6.8
name: SPDX Cryptographic Algorithm List Example
cryptoClass: Symmetric-Key-Algorithm/Encoding
commonkeySize: ['256', '512']
specifiedkeySize: {min: '128', max: '256'}
reference:
  - https://doi.org/10.17487/RFC2144
  - https://tnlandforms.us/cs594-cns96/cast.pdf
```
---

## Inclusion and Removal of Cryptographic Algorithms

This section describes the process by which algorithms are added to or removed from SPDX CryptAlg. It covers how proposals are submitted, how the Cryptography Group evaluates and decides on them, and what is required before a change reaches a pull request and is merged.

The criteria the Cryptography Group uses to decide whether an algorithm is eligible for inclusion or removal are maintained separately in the [Cryptographic Algorithm Inclusion and Removal Criteria](docs/cryptographic-algorithm-inclusion-removal-criteria.md) document. This section does not reproduce those criteria; it describes the process that applies once a proposal has been submitted.

### Proposing a New Algorithm

#### Step 1 — Open a GitHub issue

Every proposal for a new algorithm must begin with a GitHub issue in the [working repository](https://github.com/spdx/cryptographic-algorithm-list). A pull request must never be the first step. The issue is where the proposal is described, discussed, and allowed to mature before any formal review takes place.

The issue must include, at minimum:

- The proposed SPDX CryptAlg identifier (`id`) for the algorithm.
- The full name of the algorithm.
- The proposed `cryptoClass` and subclass.
- A brief justification explaining:
   - why the algorithm meets the inclusion criteria, with reference to the relevant key additional factors described in the [Cryptographic Algorithm Inclusion and Removal Criteria](docs/cryptographic-algorithm-inclusion-removal-criteria.md) document.
   - if the proposal is related to or the result of decisions, modifications or updates on algorithms approved within standardization bodies or pushed by the algorithm authors
- At least one reference to a stable, publicly accessible specification, standard, or authoritative technical document describing the algorithm.

Proposals that do not include these elements may be put on hold until the missing information is provided.

#### Step 2 — Community discussion

Once the issue is open, it is discussed asynchronously through comments and, where needed, synchronously in Cryptography Group meetings. Any conclusions or agreements reached in meetings are recorded in the issue. The issue remains open until the group has reached sufficient consensus on whether the algorithm is suitable for inclusion and, if so, on the content of its entry.

The issue should reflect its current status in the process on every step.

There is no fixed timeline for this discussion phase. Proposals that are straightforward and clearly meet the inclusion criteria may move quickly. Proposals that raise questions — about categorisation, key sizes, the right identifier, or the relationship to an algorithm already on the list — will take longer. The quality of the final entry matters more than speed.

#### Step 3 — Open a pull request

A pull request may only be opened once the Cryptography Group has reached sufficient consensus in the issue that:
- The algorithm is suitable for inclusion.
- The proposed identifier, full name, cryptoClass, and other properties are agreed upon.

The pull request must include a `.yaml` file for the algorithm, stored in the `yaml/` folder of the working repository, and named `<id>.yaml` where `<id>` is the agreed SPDX CryptAlg identifier. The file must conform to the schema defined in the working repository and must include, at minimum, all mandatory properties as defined in the [properties description file](docs/crypto-algorithms-list-properties-description.md). Submitters are strongly encouraged to also include optional properties where these are known.

The pull request description must reference the issue where the proposal was discussed.

Submissions that do not conform to the schema, or where the corresponding issue has not reached consensus, will not be merged.

#### Step 4 — Review and merge

The pull request is reviewed by the Cryptography Group following the standard review process. At least one group member other than the author must approve the pull request before it can be merged. Any group member with merge rights may merge the pull request once the review conditions are satisfied.

Once merged, the algorithm entry will be included in the next scheduled release, provided it is merged before the data freeze date defined in section 3.1 of the [release process](/DOCS/spdx-cyptographic-algorithm-list-release-process.md].

### Proposing a Correction to an Existing Entry

Corrections to existing algorithm entries — for example, fixing an incorrect `cryptoClass`, updating a key size, or adding a missing value to any property — follow a lighter version of the same process.

A GitHub issue must still be opened before a pull request, unless the correction is clearly trivial (for example, fixing a typo in the `name` field). For corrections that affect the meaning or categorisation of an entry, the issue allows the group to verify the proposed change before it is submitted for review. The pull request must reference the issue and include a plain-language description of what was changed and why.

### Proposing Removal of an Algorithm

Removal is reserved for the specific cases described in the [Cryptographic Algorithm Inclusion and Removal Criteria](docs/cryptographic-algorithm-inclusion-removal-criteria.md) document. Because removal can break downstream tools and eliminates traceability, it requires a higher level of scrutiny than other changes to the list.

A proposal to remove an algorithm must be submitted as a GitHub issue. The issue must:

- Identify the algorithm by its SPDX CryptAlg identifier.
- State clearly the reason for removal, with reference to the removal criteria.
- Describe the potential impact on downstream tools and SPDX documents that may have referenced the identifier, if known.

The Cryptography Group must reach explicit agreement — not merely the absence of objection — before a removal is approved. This agreement must be recorded in the issue. The pull request that carries out the removal must reference the issue and include a description of the impact and any migration guidance for downstream consumers.

Removal must be documented in the release notes of the release in which it occurs, including the removed identifier, the reason, and guidance for any downstream tools that may have referenced it.

## Relationship Between the Proposal Process and the Release Cycle

The proposal process described in this section — issue, discussion, consensus, pull request, review, merge — is independent of the release cadence. An algorithm entry may be proposed and discussed at any time. What the release cadence governs is when a merged change becomes part of a published release: any pull request merged before the data freeze date defined in section 3.1 of the [release process](/DOCS/spdx-cyptographic-algorithm-list-release-process.md] will be included in that month's release. Pull requests merged after the freeze will be included in the following release, except in those extraordinary cases described in the release process.

---

## About the List

* All the properties are described on the SPDX Cryptographic Algorithms List [properties description file](https://github.com/spdx/cryptographic-algorithm-list/blob/main/crypto-algorithms-list-properties-description.md).
* All the algorithms from the SPDX Cryptographic Algorithm List are included in the [yaml folder](https://github.com/spdx/cryptographic-algorithm-list/tree/main/yaml).
   * For each algorithm you will find a .yaml file, with the name <id>.yaml , where <id> is the SPDX identifier for the corresponding cryptographic algorithm
