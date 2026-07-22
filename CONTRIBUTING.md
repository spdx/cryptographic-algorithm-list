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

* Algorithm's properties and parameters are described on the SPDX Cryptographic Algorithms List [Properties and Parameters Description file](https://github.com/spdx/cryptographic-algorithm-list/tree/main/docs/crypto-algorithms-list-properties-parameters-description.md).
* All the algorithms from the SPDX Cryptographic Algorithm List are included in the [yaml folder](https://github.com/spdx/cryptographic-algorithm-list/tree/main/yaml).
   * For each algorithm you will find a .yaml file, with the name <id>.yaml , where <id> is the SPDX identifier for the corresponding cryptographic algorithm
