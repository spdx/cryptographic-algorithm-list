# SPDX Cryptographic Algorithm List Release Process

1. Introduction
2. Purpose, Scope and Repository Structure
3. Release Cadence
4. Roles and Responsibilities
5. Pre-Release Preparation ⚠️ [TO BE COMPLETED]
6. Inclusion and Removal of Cryptographic Algorithms
7. Release Workflow ⚠️ [TO BE COMPLETED]
8. Tagging & Versioning Protocol
9. Change Log & Release History
10. Post-Release Actions ⚠️ [TO BE COMPLETED]
11. Communication & Announcement
12. Release Artifacts & Distribution
13. Review and Maintenance of the Process
14. Glossary and References

---

## 1. Introduction

### 1.1 What This Document Is

This document defines the release policy for the **SPDX Cryptographic Algorithm List** (SPDX CryptAlg): a standardized, community-curated list of cryptographic algorithms maintained by the SPDX Cryptography Group.

It describes how new versions of the list are prepared, approved, published, and communicated, with the goal of ensuring that every release is consistent, traceable, and the result of an adequate review — so that downstream tools and SPDX profiles that depend on the list can rely on it with confidence. It is intended for contributors, maintainers, and anyone who consumes the list in their tools or workflows.

---

### 1.2 What the SPDX Cryptographic Algorithm List Is

The SPDX Cryptographic Algorithm List is modeled after the [SPDX License List](https://github.com/spdx/license-list-XML): a curated set of identifiers that give the software community a shared, unambiguous vocabulary for referencing a specific class of technical objects — in this case, cryptographic algorithms.

---

### 1.3 Relationship to SPDX Profiles

The SPDX Cryptographic Algorithm List is a shared resource used by different SPDX profiles — such as the Security profile and the Operations profile — as a reference for identifying cryptographic algorithms in SBOM documents. This means the list does not exist in isolation: other parts of the SPDX standard depend on it.

Because of these dependencies, not all changes to the list carry the same weight. Changes that affect the structure of the list or its property descriptions require a more careful review than algorithm entries, given their potential impact on the profiles that depend on SPDX CryptAlg. This distinction is a guiding principle throughout this release policy.

---

## 2. Purpose, Scope and Repository Structure

### 2.1 Goals

The release process is designed to achieve three goals:

**Consistency.** Every release follows the same process, regardless of the volume or nature of the changes it contains. This ensures that the list remains reliable and that downstream consumers can integrate updates without surprises.

**Traceability.** Every change included in a release can be traced back to the issue where it was discussed and the pull request where it was reviewed. Nothing reaches a release without a record of how it got there.

**Adequate review.** Not all changes require the same level of scrutiny. Algorithm entries and corrections can move through the process relatively quickly. Changes that affect the structure of the list or property descriptions require broader consultation, given their potential impact on the SPDX profiles that depend on SPDX CryptAlg.

---

### 2.2 What This Process Covers

This release policy applies to the following:

- Algorithm entries in the working repository, including new additions, corrections, and removals.
- Property descriptions and any changes to the structure of the list.
- The JSON output published in the data repository at each release.
- The documentation that accompanies the list, such as the contributing guide and the properties description file.

---

### 2.3 What This Process Does Not Cover

This release policy does not govern:

- The release of downstream tools that consume SPDX CryptAlg, including SCA scanners or SBOM generators.
- The release process of the SPDX specification or any of its profiles.
- The release process of the SPDX License List or any other SPDX-maintained list.

Those are independent processes managed by their respective communities. Where coordination is needed — for example, when a structural change to SPDX CryptAlg may affect a profile — that coordination is handled through the relevant SPDX working groups, but the decisions and timelines remain separate.

---

### 2.4 The Two-Repository Model

SPDX CryptAlg uses a two-repository model, following the same approach as the SPDX License List (`license-list-XML` and `license-list-data`). Understanding this model for the License List is essential to understanding how SPDX Cryptographic Algorithm List releases and deployments work.

**Working repository: `cryptographic-algorithm-list`**

This is where all authoring and community work happens. We sometimes refer to it as "input repo". New algorithm entries, changes to existing ones, and updates to property descriptions are first discussed and shaped in GitHub issues. Pull requests are only opened once the content is considered mature enough for formal review. Every pull request, review, and group decision lands here. This repository is the source of truth for the content of the list. Each algorithm is described in a dedicated `.yaml` file, one per algorithm, stored in the `yaml/` folder of this repository.

This repository does not produce releases directly. It is an input, not a distribution channel.

**Data repository: `cryptographic-algorithm-list-data`**

This is the repository where the released version of the Cryptographic Algorithm List is deployed. We often refer to it as the "output repo". At each release, the content of the working repository is processed and a set of output files is generated and published here. This is the repository that downstream tools and consumers should point to.

The output format is JSON, following the JSON schema used across the SPDX ecosystem. JSON Schema is a standard way of describing the structure and constraints of JSON data: it specifies what fields are expected, what types they hold, and what values are valid. Using the SPDX JSON schema ensures that SPDX CryptAlg outputs are consistent with other SPDX data and can be consumed directly by tools that already support the SPDX format, without requiring those tools to learn a new data structure. No other output formats — such as HTML or XML — are produced at this stage.

Each version published in the data repository corresponds to a tagged state of the working repository. The data repository contains only generated outputs; it is never edited by hand.

This separation keeps the authoring workflow clean and gives consumers a stable, predictable place to find versioned data, independently of the ongoing activity in the working repository.

### 2.5 The Website

The SPDX Cryptographic Algorithm List is published as a human-readable website at:

**`https://spdx.github.io/cryptographic-algorithm-list`**

This site is the primary point of discovery for anyone looking to understand or browse the list. It is modeled after the SPDX License List website (`https://spdx.org/licenses/`) and the SPDX specification website (`https://spdx.github.io/spdx-spec/`), both of which publish structured technical content as static sites generated from source repositories.

The website is built with [MkDocs](https://www.mkdocs.org/) using a theme provided by Read the Docs, and is deployed automatically via GitHub Actions on each release. It is generated from the content of the -data repository (output repo) at the time of each tagged release. The website is never edited by hand.

**Structure of the website**

The website contains the following pages:

- **Home page** — An introductory description of the SPDX Cryptographic Algorithm List and its purpose, including a browsable table of all algorithms showing their full name, short identifier (`id`), and cryptographic class (`cryptoClass`).
- **Properties Description** — An explanation of all properties used in the `.yaml` files, corresponding to the properties description document maintained in the working repository.
- **Algorithm Inclusion Principles** — The criteria the Cryptography Group uses to evaluate whether an algorithm is eligible for inclusion in the list.
- **Contributing** — Guidance for contributors on how to propose new algorithms, report errors, and participate in the review process.
- **Individual algorithm pages** — A dedicated page for each algorithm in the list, accessible at a predictable URL based on the algorithm identifier (e.g., `https://spdx.github.io/cryptographic-algorithm-list/3des.htm`). Each page presents the full set of properties for that algorithm.
- **Links to the GitHub repositories** — Direct links to both the working repository and the data repository, so that users can access the source files and machine-readable outputs.

### 2.6 The Parser

The parser — referred to as `cryptalg-parser` — is the tool that reads the `.yaml` algorithm files in the input repo and generates the output artifacts that are published at each release. It is hosted inside the input repo (`cryptographic-algorithm-list`), making it co-located with the source data it processes.

The `cryptalg-parser` is modeled after two tools used elsewhere in the SPDX ecosystem:

- The [`spec-parser`](https://github.com/spdx/spec-parser), which reads the SPDX 3 model files (written in a constrained Markdown format, stored in `spdx-3-model`) and generates MkDocs input, PlantUML diagrams, JSON dumps, and other outputs used to publish the SPDX specification website.
- The [`LicenseListPublisher`](https://github.com/spdx/LicenseListPublisher), which reads the XML source files in `license-list-XML` and generates the RDFa, HTML, text, and JSON output formats published in `license-list-data` and on the SPDX License List website.

For SPDX CryptAlg, the parser takes the `.yaml` files stored in the `yaml/` folder of the working repository as its input, and produces two categories of output:

- **JSON files**, which are published in the -data repository (`cryptographic-algorithm-list-data`) and consumed directly by downstream tools and SBOM generators.
- **Static web pages**, which are used by MkDocs to generate the website described in section 2.5.

The parser runs as part of the automated release pipeline, triggered by GitHub Actions at release time. It is never run manually during normal operations; its execution is part of the release workflow defined in section 7.

Because the parser is hosted in the working repository, any changes to it — including bug fixes, new output formats, or schema validation improvements — are subject to the same review process as changes to the algorithm data itself. Modifications to the parser that affect the structure of the generated outputs are treated as structural changes and require the broader consultation described in section 2.1.

---

## 3. Release Cadence

### 3.1 Monthly Release Schedule

SPDX CryptAlg targets a monthly release cadence. The intention is to publish a new version once per month, on a scheduled basis, regardless of the volume of changes accumulated since the previous release. Every change merged into the working repository before the freeze date is expected to be included in that month's release.

This regular cadence gives downstream tools and consumers a predictable integration rhythm, and ensures that improvements — even minor ones — reach users quickly rather than accumulating for long periods. It also avoids the overhead of managing long release cycles while the list is still maturing.

At this early stage of the list's life cycle, some flexibility in the cadence and freeze dates may be needed. The monthly target should be treated as a commitment the group works toward, rather than a rigid constraint. Where circumstances require adjusting a release date, the decision will be documented and communicated through the usual channels. Skipping a release cycle is a no-action event: the Cryptography Group may decide to skip a release without any further process or communication required.

#### Hot Releases

An additional, unscheduled release (hot release) may be issued outside the monthly cadence in exceptional circumstances. These include, but are not limited to:
- A critical correction that would lead downstream tools to produce materially incorrect outputs if left until the next scheduled release.
- An urgent change driven by SPDX
- A relevant security event or standardization body decision

Hot releases follow the same versioning scheme as regular releases. The release notes (CHANGELOG.md) must explain why a hot release was necessary.

#### Data Freeze

To be included in a given monthly release, a pull request must be merged into the working repository no later than 7 calendar days before the scheduled release date. Changes merged after the freeze will be included in the following month's release. This period allows time for pre-release checks, release note drafting, and JSON output generation in the data repository.

Changes merged after that data freeze date will be included by default in the following month's release. In exceptional circumstances, the person appointed by the Cryptography Group for that release might add the changes to the coming release. Such cherry picking should be justified within the Cryptography Group and recorded in the release notes.

## 4. Roles and Responsibilities

Each release involves two roles: a Release Coordinator and the Reviewers. Both are filled by members of the Cryptography Group.

### 4.1 Release Coordinator

For each release, the Cryptography Group appoints one of its members as Release Coordinator. The appointment is made by consensus within the group. There is no permanent or standing Release Coordinator: the role is assigned on a per-release basis, allowing the responsibility to be shared across group members over time.

The Release Coordinator has all the rights necessary to carry out the release, including the ability to create and merge branches, tag versions in both repositories, trigger validation and generation scripts, publish the release in the data repository, and update the associated documentation. These rights are scoped to the release process and exercised in accordance with the conditions and actions described in the preceding sections of this policy.

The Release Coordinator is responsible for driving the release to completion: coordinating the pre-release checks, drafting or overseeing the release notes, cutting the tag, and ensuring the release is published and announced correctly.

### 4.2 Reviewers

The Reviewers are the remaining members of the Cryptography Group who are not acting as Release Coordinator for a given release. Their role is to support the Release Coordinator by reviewing the actions taken throughout the release process — checking that pre-release conditions are met, that the release notes are accurate and complete, and that the published output is consistent with the content of the working repository.

Reviewers do not block the release unilaterally, but their feedback must be addressed before a release is considered ready to publish. Any unresolved concern should be escalated to the full group for a decision.

---

## 5. Pre-Release Preparation ⚠️ [TO BE COMPLETED]

### What to Include

- How changes that may go into a release are collected: issues labeled "crypto-list: candidate", PR labels, milestones (e.g., milestone: CryptAlg v0.2).
- Process for triaging: who reviews issues/PRs, how to move them in or out of the milestone.
- Update of documentation, test plan, schema validation.
- Release process life cycle:
  - Release process stages
  - Actions and Notifications on each stage
  - PR merge deadline

### Why Include It

- Ensures releases are intentional, not just "whatever was merged lately".
- Ensures the release artifact is complete and verified.
- Makes it easier to produce accurate release notes (you know which PRs were "in scope").
- Helps manage backlog vs. release-blocking issues.

## 6. Inclusion and Removal of Cryptographic Algorithms

Determining whether a candidate algorithm should be included in or removed from the **SPDX Cryptographic Algorithm List (SPDX CryptAlg)** requires the **Cryptography Group** to engage in a case-by-case evaluation of every proposal. This section defines the governance framework for these changes and their impact on the release cycle.

### 6.1 Evaluation Criteria

The specific factors used to determine if an algorithm is eligible for inclusion (such as standardization, industry adoption, or academic use) or removal (such as duplicate entries or data quality issues) are maintained in the [Cryptographic Algorithm Inclusion and Removal Criteria](docs/algorithm-inclusion-principles.md) document. The Cryptography Group uses these principles to ensure the list remains a reliable, fact-based resource for the software community.

### 6.2 Submission and Review Process

The technical workflow for proposing changes—including the requirement to open a GitHub issue before a pull request and the stages of community discussion—is detailed in the [CONTRIBUTING.md](CONTRIBUTING.md) file.

From a release management perspective, the following rules apply:
*   Consensus Requirement: A change is only eligible for a release once the Cryptography Group reaches sufficient consensus in the corresponding GitHub issue.
*   Data Freeze: To be included in a scheduled release, the corresponding pull request must be merged before the data freeze date, which is 7 calendar days prior to the release.

### 6.3 Removal Policy

The SPDX CryptAlg prioritizes **traceability** and **backward compatibility** to ensure that downstream tools and SPDX profiles and documents remain valid over time. Consequently, the list follows a strict policy regarding the persistence of identifiers:

*   Persistence of Entries: An algorithm will **not** be removed from the list simply because it has been withdrawn by a standards body, is considered cryptographically weak, or has fallen out of use. These entries are retained to ensure that existing SBOM data remains identifiable and traceable.
*   Removal for Errors: Removal is an exceptional action reserved strictly for entries added in error, such as fictitious algorithms, duplicate entries, or fundamental data quality issues that cannot be corrected in place.
    *   Governance: Any removal requires explicit, recorded agreement from the Cryptography Group rather than a mere absence of objection.
    *   Release Documentation: All removals must be explicitly documented in the CHANGELOG.md of the release in which they occur. This entry must include the removed identifier, the reason for removal, and migration guidance for downstream tool maintainers.

---

## 7. Release Workflow ⚠️ [TO BE COMPLETED]

### What to Include

- Step-by-step sequence from branch creation → tests → tagging → publishing.
- Criteria for approving a release: all required checks passed, release notes drafted, issues in the milestone closed or moved, schema changes reviewed.
- Formal approval process
  - List of mandatory checks before cutting a release and how these checks are run
  - Policy for what happens if a check fails (release is blocked, who can override).

### Why Include It

Makes the governance around releases explicit and transparent
- Creates a reliable, repeatable process.
- Guarantees a minimum quality level for every release, since it ensures community and expert review before data is considered "official"
- Makes releases repeatable and reduces regressions.
- Reduces the risk of unilateral or rushed releases
- Provides confidence for downstream users that the list is internally consistent.


## 8. Tagging & Versioning Protocol

### 8.1 Versioning Scheme

Each release is identified by a version string with the following format:

```
<generation>.<YYYY>.<MM>.<DD>.<hh>.<mm>
```

Where:

- **`<generation>`** is a positive integer representing a major era of the list. It starts at `1` and is incremented only when a breaking change is introduced — that is, a change that would require downstream consumers or SPDX profiles to adapt their integration in a non-trivial way. Examples include a fundamental restructuring of the `.yaml` schema, a change in the semantics of a core property, or a renaming of algorithm identifiers at scale. As noted in section 1.3, such changes require broader consultation and explicit group agreement before they can be merged. Increments to the generation number are therefore expected to be rare.
- **`<YYYY>.<MM>.<DD>`** is the calendar date of the release, in ISO 8601 format.
- **`<hh>.<mm>`** is the time of the release in UTC, using a 24-hour clock. This component is part of the canonical version string but may be omitted in human-facing communications — announcements, changelogs, documentation — where the date alone is sufficient to identify the release unambiguously.

**Examples:**

| Canonical version | Shortened form (for communications) |
|---|---|
| `1.2025.10.01.14.00` | `1.2025.10.01` |
| `1.2026.02.05.09.30` | `1.2026.02.05` |
| `2.2026.06.01.10.00` | `2.2026.06.01` (generation increment) |

The date-based versioning scheme makes the release history immediately readable — any consumer can tell at a glance when a version was produced — while the generation number provides a clear, unambiguous signal when breaking changes occur.

### 8.2 Tagging and Publication

Each release is tagged in both repositories:
* `cryptographic-algorithm-list`
* `cryptographic-algorithm-list-data`

using the canonical version string (e.g., `1.2026.02.05.09.30`).

GitHub Releases are used to publish each version, with the release notes (CHANGELOG.md file) associated directly to the corresponding tag. The ultimate goal is that anyone can trace the correct release in both repositories, the corresponding data, the release notes, and the release history (RELEASE-HISTORY.md) files.

### 8.3 Branching Strategy

The Cryptography Group has agreed on avoiding feature and release branches as much as possible, practicing what is usually called trunk-based development. So the branching strategy is no-branching.

---

## 9. Change Log & Release History

Every release of SPDX CryptAlg produces a record of what changed. This record serves two purposes. For downstream consumers — tools, SBOM generators, integrators — it communicates what has changed and whether any action on their side is required. For contributors and the Cryptography Group itself, it creates a traceable history that connects each release to the issues and pull requests that shaped it.

This section defines how that record is maintained: what files are used, what content is required in each, and how the release notes are assembled during the release workflow.

The change log and release history are maintained in two separate files in the root of the working repository (`cryptographic-algorithm-list`):

**`CHANGELOG.md`** is the primary release documentation file. It contains the full release notes for every published version, in reverse chronological order — most recent release first. Each entry documents what changed in that release: new algorithm entries, corrections, deprecations, schema changes, and any other relevant information. This file grows with every release and is the canonical source of release notes for SPDX CryptAlg. It is this file that is linked from GitHub Releases and referred to in release announcements.

**`RELEASE-HISTORY.md`** is a compact table listing all published versions and their release dates, in reverse chronological order. It provides a quick reference for anyone who needs to identify when a specific version was published, without reading through the full changelog. It follows the same format as the `RELEASE-HISTORY.md` file of the SPDX License List.

Both files are stored in the root of the working repository and kept under version control. They are updated as part of the release workflow and committed before the release tag is cut.

---

### 9.1 Content Requirements for CHANGELOG.md Entries

Each release entry in `CHANGELOG.md` must begin with a level-two heading that identifies the release version and date, using the following format:

```
## <version> — <YYYY-MM-DD>
```

Where `<version>` is the shortened form of the canonical version string (e.g., `1.2026.03.01`), as defined in section 8.1. The date uses ISO 8601 format.

The body of each entry must cover the following categories, as applicable. A category may be omitted if it has no content for a given release, with one exception: the **Algorithm entries** section is always present, even if no entries were added, corrected, or deprecated in that release.

**Algorithm entries added.** A numbered list of all new algorithm entries included in the release, identified by their SPDX CryptAlg identifier. Each entry should include a brief parenthetical note when the reason for addition is not self-evident — for example, when an algorithm was added in response to a specific standardisation body decision or a security event.

**Algorithm entries corrected.** A description of any corrections made to existing entries, including the identifier of the corrected algorithm and a plain-language explanation of what was changed and why. Corrections to a property value (for example, a `cryptoClass` correction or a key size fix) should name the property and describe the before/after change.

**Algorithm entries deprecated.** A list of any identifiers that have been deprecated in this release, with a brief explanation of the reason and — where applicable — the identifier of the superseding or related entry.

**Algorithm entries removed.** Removal is rare and reserved for the specific cases described in section 6.3 of this policy. When it occurs, the removed identifier must be listed explicitly, the reason must be stated, and guidance must be provided for downstream tools that may have referenced the removed identifier.

**Schema changes.** A description of any changes to the `.yaml` schema used in the working repository or to the JSON schema used in the data repository. Schema changes should clearly indicate whether the change is backwards-compatible or whether it may require adaptation by consumers. Migration notes should be included when a consumer action is needed.

**Documentation and tooling changes.** A brief description of any significant changes to documentation, the parser, CI scripts, or other tooling included in the release.

**Known issues.** Any issues known at the time of release that downstream consumers should be aware of, with links to the relevant GitHub issues.

**Hot release rationale.** If the release is a hot release issued outside the regular monthly cadence, the entry must include an explicit statement of why the hot release was necessary. This is required by section 3.1 of this policy.

Each changelog entry must also include a link to the milestone in the working repository listing all pull requests included in the release, and — where available — a link to the diff comparing the previous release to the current one. These links are the primary mechanism for tracing the release back to its constituent changes. Contributors are encouraged to draft changelog entries as they submit and merge pull requests, rather than writing the entire entry at release time: a brief note in the PR description describing the change in changelog-ready language reduces the burden on the Release Coordinator and improves the quality of the final notes.

---

### 9.2 RELEASE-HISTORY.md Format

`RELEASE-HISTORY.md` is a simple Markdown table listing all published releases in reverse chronological order. It uses the shortened version string and the release date, following this format:

```markdown
# Release History of the SPDX Cryptographic Algorithm List

| Release | Date |
| ------- | ---- |
| 1.2026.03.01 | 2026-03-01 |
| 1.2026.02.05 | 2026-02-05 |
```

A new row is added to the top of the table for each release, including hot releases, at the time the release tag is cut. The shortened version string is used in the table; the canonical version string (including the time component) is available via the tag in the repository.

---

### 9.3 Process: From Issue and Pull Request to Changelog Entry

The changelog is not written in one sitting at release time. It is assembled progressively across the lifecycle of the release, drawing on the issues and pull requests that constitute it.

The recommended practice is as follows. When a pull request is submitted for review, the author includes a brief description of the change in changelog-ready language in the PR description — no more than one or two sentences for a typical algorithm entry. When the PR is merged, the Release Coordinator or the author adds a corresponding line to a working draft of the `CHANGELOG.md` entry for the upcoming release. This draft is maintained in the working repository between releases, either as an in-progress section at the top of `CHANGELOG.md` or as a dedicated issue or discussion thread used for drafting purposes.

In the pre-release phase, the Release Coordinator consolidates the working draft into the final changelog entry, ensures all merged PRs are accounted for, and verifies that the entry is complete and accurate before it is committed as part of the release. Reviewers are responsible for checking the accuracy and completeness of the changelog entry before the release tag is cut.

This incremental approach reduces the risk of incomplete or inaccurate release notes and ensures that the traceability goals of this policy — connecting every change to the issue and PR where it was discussed and reviewed — are met in practice.

---

### 9.4 Relationship to GitHub Releases

At the time of publication, the Release Coordinator creates a GitHub Release in the working repository associated with the release tag. The body of the GitHub Release is the changelog entry for that version, copied from `CHANGELOG.md`. This makes the release notes discoverable directly from the GitHub interface without requiring users to navigate to the file.

The data repository (`cryptographic-algorithm-list-data`) is tagged with the same canonical version string at the same time, as described in section 8.2. The GitHub Release in the data repository may reference the changelog entry in the working repository rather than duplicating it.

---

## 10. Post-Release Actions ⚠️ [TO BE COMPLETED]

### What to Include

- Updating default branch to dev or next milestone branch.
- Closing associated issues/milestones.
- Roll-back and hot fixes policy
  - How to handle critical fixes post-release.
  - What happens when the release goes wrong and roll-back is the sane option
- Monitor user feedback or reported issues related to the new release.

### Why Include It

- Keeps things tidy and prepares for next cycle.
- Stay prepared for the unpredictable: ensures a reliable process for urgent issues.
- Helps capture lessons and feed them back into the process.
- Avoids outdated docs and stale milestones.

## 11. Communication & Announcement

### 11.1 Communication Channels

SPDX CryptAlg uses two dedicated mailing lists for release-related communications.
* The SPDX general discussion mailing list, spdx@lists.spdx.org, is the primary channel for release announcements and general interactions with the community. All release announcements are published here, and it is the main venue for community engagement around new versions of the list.
* The SPDX CryptAlg tooling and downstream consumers mailing list, spdx-cryptalg-list-users@lists.spdx.org, is a dedicated channel for alerts and communications specifically relevant to tooling integrators and downstream consumers of the list. This list is used when a release contains changes that may affect how the list is consumed programmatically, or when an issue is identified after publication that requires prompt attention from tool maintainers. Not every release requires a message to this list; the Release Coordinator exercises judgement based on the nature of the changes.

### 11.2 Responsibility for Announcements

The Release Coordinator is responsible for drafting and sending all release announcements and post-release alerts. Announcements are sent after the release tag has been cut, the output has been published in the data repository, and the website has been updated — that is, once the release is fully complete and all artifacts are publicly accessible.

### 11.3 Release Announcement

For every published release, the Release Coordinator sends an announcement to the SPDX general discussion mailing list. If the release contains changes relevant to tooling or downstream consumers, the same announcement is also sent to the tooling and downstream consumers mailing list.
The announcement must include the following elements:
* Release tag — the canonical version string identifying the release.
* List on the website — a link to the version of the list published on the SPDX CryptAlg website corresponding to this release.
* Output repository — a link to the corresponding version of the data repository (cryptographic-algorithm-list-data), where the generated JSON output is published.
* Tagged version in the input repository — a link to the tagged version in the working repository (cryptographic-algorithm-list), which is the source of truth for the content of the release.
* Release notes — a link to the changelog entry for this release, as published in CHANGELOG.md or in the GitHub Release.
* Further news — any additional information relevant to users and integrators, such as upcoming structural changes, deprecation notices, coordination items with other SPDX working groups, or known issues identified after publication.

### 11.4 Post-Release Alerts

If an issue is identified after a release has been published — for example, an error in an algorithm entry, an inconsistency in the generated output, or a problem affecting downstream tooling — the Release Coordinator sends an alert to the tooling and downstream consumers mailing list as soon as the issue is confirmed. The alert describes the nature of the problem, its potential impact, and the expected timeline for a correction. If a hot release is warranted, the alert precedes or accompanies the hot release announcement.

Alerts of general interest to the broader community are also posted to the SPDX general discussion mailing list.

## 12. Release Artifacts & Distribution

### 12.1 Sources of Truth

SPDX Cryptographic Algorithm List has two equivalent and complementary sources of truth for any published release.
* The data repository (cryptographic-algorithm-list-data) is the primary distribution channel for machine-readable consumers. It contains the generated outputs of each release and is the repository that downstream tools, SBOM generators, and integrators should point to. It is never edited by hand: every file it contains is generated automatically by the cryptalg-parser at release time.
* The website (https://spdx.github.io/cryptographic-algorithm-list) is the primary discovery point for human readers. It presents the same content as the data repository in a human-readable form. Both represent the same canonical state of the list at any given release and can be treated as equivalent sources of truth, one for machines and one for people.
* The working repository (cryptographic-algorithm-list) is the source of truth for the content of the list — the .yaml files, the parser, the release tooling, and the accompanying documentation. It is not a distribution channel. Downstream consumers should not integrate against the working repository directly.

### 12.2 Output Formats

At each release, the cryptalg-parser reads the .yaml files in the yaml/ folder of the working repository and produces two categories of output:
* JSON files, published in the data repository (cryptographic-algorithm-list-data). These are the machine-readable artifacts intended for downstream tools and integrators. The JSON output follows the JSON schema used across the SPDX ecosystem, ensuring that the list can be consumed directly by tools that already support the SPDX format without requiring changes to their data handling. No other machine-readable formats — such as XML or CSV — are produced at this stage.
* Static web pages, used by MkDocs to generate the website. These present the content of the list in a human-readable form, including individual pages for each algorithm entry and supporting pages for properties descriptions, inclusion principles, and contributing guidance. The website is deployed automatically by GitHub Actions on each release and is never edited by hand.

The working repository also contains, at the tagged release version, the same content as the data repository — in .yaml format. This allows any consumer who needs the source representation, rather than the generated output, to find it in the working repository at the corresponding tag.

### 12.3 Release Tooling

All tools used to produce and publish a release are hosted in the working repository (cryptographic-algorithm-list). This co-location ensures that the tooling version used for any given release is always traceable: the tag applied to the working repository at release time captures not only the list content and documentation, but also the exact version of the parser and automation scripts that produced that release's output.

The primary tool is the cryptalg-parser, described in section 2.6. It is responsible for reading the .yaml source files and generating the JSON output and static web pages published at each release. The parser is invoked automatically as part of the GitHub Actions release workflow and is never run manually during normal operations.

All other release automation — including the scripts and workflows that trigger the parser, publish output to the data repository, deploy the website, and apply release tags — is implemented as GitHub Actions workflows, also hosted in the working repository.

### 12.4 Governance of the Release Tooling

The release tooling follows the same governance model as the list itself. In general, proposed changes — whether bug fixes, new output formats, schema validation improvements, or automation updates — are first raised and discussed in GitHub issues in the working repository. A pull request is opened once the proposed change has been discussed and considered mature. Except for trivial ones, changes do not mature in pull requests; they generally mature in issues. The goal of this procedure is keeping reviews focused and avoids requiring advanced Git skills from contributors who want to participate in the discussion without contributing code directly.

Changes to the tooling that affect the structure of the generated outputs — for example, modifications to the JSON schema or changes to the set of files published in the data repository — are treated as structural changes under section 2.1 and require the broader consultation described there before they can be merged.

### 12.5 No Manual Edits to Generated Artifacts

Neither the data repository nor the website is ever edited by hand. Any change to the content of the list must be made in the .yaml source files in the working repository, reviewed and merged through the standard process, and reflected in the generated outputs via the next release. The same applies to the documentation that is part of the release, published on the website. This principle ensures that the working repository remains the single authoritative source for list content, and that the outputs in the data repository and website are always reproducible from that source.

Critical changes in the release process will be communicated to the SPDX community.

## 13. Review and Maintenance of the Process

### 13.1 Location of This Document

This release policy is maintained as release-process.md inside the docs/ folder of the working repository (cryptographic-algorithm-list). It lives alongside the other policy and reference documents that govern the list, such as algorithm-inclusion-principles.md and crypto-algorithms-list-properties-description.md. Being version-controlled in the working repository means that every change to this document is traceable in the same way as changes to the list content itself.

### 13.2 Versioning of This Document

This document follows the same release versioning scheme as the list itself, as defined in section 8. Each published version of the list is associated with the version of this policy that was in effect at the time of that release. Changes to this document are included in the CHANGELOG.md entry of the release in which they take effect, under a dedicated section that clearly identifies them as process changes rather than list content changes.

### 13.3 Process for Proposing and Approving Changes

Changes to this release policy follow exactly the same governance model as changes to the list itself.

A proposed change is generally first raised as a GitHub issue in the working repository. Except for simple changes, the issue is where the change is described, discussed, and allowed to mature. Both asynchronous discussion — through comments in the issue — and synchronous discussion — in Cryptography Group meetings — happen with reference to the issue, and any conclusions or agreements reached in meetings are recorded there. A pull request is created once the proposed change has been discussed, refined, and considered ready for formal review. As a general procedure, changes do not mature in pull requests; they mature in issues.

The pull request is reviewed and approved by the Cryptography Group following the standard review process. No change to this document is merged without completing that process.

### 13.4 Communication of Relevant Changes

Changes to this release policy that may affect other SPDX working groups — for example, modifications to how structural changes are coordinated, changes to the versioning scheme, or changes to the release cadence — are communicated to the broader SPDX community as well as downstream consumers, before they take effect. The purpose of this communication is to identify and resolve any incompatibilities or friction with other SPDX groups and tooling integrators that depend on or interact with SPDX CryptAlg. The appropriate communication channel for this follows section 11.1.

Not every change to the release policy requires this broader communication. The Cryptography Group exercises judgement on whether a proposed change has implications beyond the group's own workflows. When in doubt, communicating is the preferred option.

## 14. Glossary and References

### 14.1 Key Terms

* Algorithm Inclusion Principles — The criteria used by the Cryptography Group to evaluate whether a candidate cryptographic algorithm is eligible for inclusion or removal in SPDX CryptAlg. Maintained as cryptographic-algorithm-inclusion-removal-criteriav.md in the docs/ folder of the working repository.
* Breaking change — A change that requires downstream consumers, integrators, or SPDX profiles to adapt their integration in a non-trivial way. Examples include a fundamental restructuring of the .yaml schema, a change in the semantics of a core property, or a renaming of algorithm identifiers at scale. A breaking change increments the generation number in the version string.
* Canonical version string — The full version identifier assigned to a release, following the format <generation>.<YYYY>.<MM>.<DD>.<hh>.<mm>. It is used as the release tag applied to both repositories.
* Cryptography Group — The SPDX working group responsible for maintaining the SPDX Cryptographic Algorithm List. It is the group that makes decisions about algorithm entries, structural changes, release approvals, and the governance of the release process.
* cryptalg-parser — The tool that reads the .yaml algorithm files in the working repository and generates the JSON output and static web pages published at each release. It is hosted in the working repository and runs automatically as part of the GitHub Actions release pipeline.
* Data freeze — The point in the release cycle after which no further pull requests are merged into the working repository for inclusion in the upcoming release. Set at 7 calendar days before the scheduled release date.
* Data repository — The repository cryptographic-algorithm-list-data, where the generated outputs of each release are published. It contains the JSON files consumed by downstream tools and the static pages used to build the website. It is never edited by hand.
* GitHub Actions — The automation platform used to run the release pipeline, including triggering the cryptalg-parser, publishing output to the data repository, deploying the website, and applying release tags. All workflows are hosted in the working repository.
* Hot release — An additional, unscheduled release issued outside the monthly cadence in exceptional circumstances, such as a critical correction affecting downstream tool outputs or an urgent security event.
* Input repository — See working repository.
* MkDocs — The static site generator used to build and publish the SPDX CryptAlg website, using a theme provided by Read the Docs.
* Output repository — See data repository.
* Release Coordinator — The member of the Cryptography Group appointed on a per-release basis to drive a given release to completion. Responsible for pre-release checks, release notes, tagging, publication, and announcement.
* Release tag — The canonical version string applied as a Git tag to both the working repository and the data repository at the time a release is published.
* Reviewers — The members of the Cryptography Group who are not acting as Release Coordinator for a given release. They are responsible for reviewing the release actions, checking pre-release conditions, and verifying the accuracy and completeness of the release notes.
* Shortened version string — A condensed form of the canonical version string that omits the time component, used in RELEASE-HISTORY.md and human-facing communications. Example: 1.2026.03.01.
* SPDX Cryptographic Algorithm List — The full canonical name of the list maintained by the SPDX Cryptography Group: a standardized, community-curated set of identifiers for cryptographic algorithms used in SBOM documents.
* SPDX CryptAlg — The official short name for the SPDX Cryptographic Algorithm List. Used in place of the full name throughout this document and in communications, tooling, and repository references.
* Structural change — A change that affects the structure of the list or its property descriptions, rather than individual algorithm entries. Structural changes require broader consultation within the Cryptography Group and, where relevant, coordination with other SPDX working groups.
* Working repository — The repository cryptographic-algorithm-list, where all authoring and community work happens. It is the source of truth for the content of the list, the release tooling, and the accompanying documentation. Also referred to as the input repository.

### 14.2 References

Repositories
* Working repository (input repo): https://github.com/spdx/cryptographic-algorithm-list
* Data repository (output repo): https://github.com/spdx/cryptographic-algorithm-list-data

Website
* SPDX Cryptographic Algorithm List website: https://spdx.github.io/cryptographic-algorithm-list

Documents in the SPDX CryptAlg working repository
* The SPDX Cryptographic Algorithms List [Release Process](docs/release-process.md) describes the release policy and procedures
* The [Algorithm Inclusion and Removal Principles](docs/algorithm-inclusion-principles.md) document describes the criteria that the Cryptography Group follows to evaluate and approve or reject the any submitted proposal to add or remove a cryptographic algorithm to the List
* The [Properties Description](crypto-algorithms-list-properties-description.md) document describes all the properties that characterize a cryptographic algorithm included on the List as well as their values
* The contribution to the List guidelines are summarised in the [Contributing Guide](CONTRIBUTING.md).
* The [RELEASE-HISTORY](RELEASE-HISTORY.md) document is a compact Markdown table maintained in the root of the working repository, listing all published releases in reverse chronological order with their shortened version string and release date.
* The Release Notes or [Changelog](CHANGELOG.md) contains the full release notes for every published version in reverse chronological order.

Other related SPDX projects
* SPDX License List working repository: https://github.com/spdx/license-list-XML
* SPDX License List data repository: https://github.com/spdx/license-list-data
* SPDX License List website: https://spdx.org/licenses/
* SPDX Specification: https://spdx.github.io/spdx-spec/v3.0.1/
* SPDX spec-parser: https://github.com/spdx/spec-parser
* SPDX LicenseListPublisher: https://github.com/spdx/LicenseListPublisher
