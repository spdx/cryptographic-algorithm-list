# Cryptographic Algorithm Inclusion and Removal Criteria

Determining whether a candidate algorithm should be included in the SPDX Cryptographic Algorithm List (SPDX CryptAlg) requires the Cryptography Group to engage in a case-by-case evaluation of each submission based on a number of factors. The criteria below set out an order of priority for that evaluation. They are not exhaustive: the ultimate decision will be based on the totality of the factors and the goals of the list as described in the release process document.

## Criteria for Inclusion

### Key factors

An algorithm that meets any of the following will be included:
* The algorithm has been standardised by a recognised standardisation body, including but not limited to NIST, ISO/IEC, ETSI, IETF, IEEE, or national standards bodies. Both current standards and those that have been withdrawn or superseded are eligible, as withdrawn standards may still appear in existing software and systems.
* The algorithm is or has been widely used in industry or commercial software, regardless of whether it was formally standardised. Demonstrated adoption across multiple products, ecosystems, or vendors is sufficient.
* The algorithm has had or continues to have significant use in academic research or as a reference implementation in the cryptographic community, such that it is likely to appear in real-world software or SBOM data.

### Additional factors

For algorithms that do not clearly meet one of the key factors above, the Cryptography Group will consider the following, roughly in order of importance:

1. The algorithm has a stable, identifiable specification — whether a standards document, a peer-reviewed paper, or a well-established technical reference — such that its definition is unambiguous and unlikely to change.
2. The algorithm has actual, demonstrable use in software that is packaged, distributed, or analysed with SBOM tooling. Substantial use may be demonstrated through presence in multiple projects, or in one or a few significant ones.
3. The algorithm has a well-known identifier or name within the community it comes from, reducing the risk of ambiguity or duplication.
4. The algorithm is not already represented on the list under a different identifier. Submissions that duplicate an existing entry will not be accepted; a correction to an existing entry should be submitted as a property update rather than a new algorithm.

The Cryptography Group may also consider any additional information provided by the submitter or raised by the community during the review process.

## Criteria for Removal

Removal from the list is reserved for cases where an entry was added in error. Examples include:

- A duplicate entry that matches an algorithm already on the list under a different identifier.
- A submission based on a non-existent or fictitious algorithm.
- An entry with a fundamental data quality problem that cannot be corrected in place.

Removal in such cases requires explicit agreement from the Cryptography Group and must be documented in the release notes of the release in which it occurs, with guidance for any downstream tools that may have referenced the removed identifier.

An algorithm already on the list will not be removed simply because:

- A standardisation body has formally withdrawn, revoked, or replaced it.
- It is widely considered cryptographically broken or unsafe by the security community.
- It has fallen entirely out of use and is no longer encountered in real-world software or SBOM data.
- It is considered obsolete, or no longer recommended.

Removal would break downstream tools and undermine the traceability that SPDX CryptAlg is designed to provide.

## Historical Background

The SPDX Cryptographic Algorithm List is modeled after the [SPDX License List](https://spdx.org/licenses/). The inclusion and removal criteria in this document follow the same philosophy: the purpose of SPDX CryptAlg is not to evaluate the security or appropriateness of cryptographic algorithms, but to reliably and consistently communicate and share objective factual information about them, so that organisations using software components will have the information necessary to conduct their own independent analysis.

Because the present focus of SPDX CryptAlg is the identification of cryptographic algorithms as they appear in software, any algorithm that is or has been used in real-world software is a candidate for inclusion, regardless of its current security status or standardisation standing.
