# SPDX Cryptographic Algorithms List properties description

## Id

* Description: univocal identifier for every cryptographic algorithm. This list provides an identifier per algorithm.
* Values: alphanumeric, where the usage of lower or upper case characters depend on each algorithm

## Name

* Description: widely accepted name provided by the author of the algorithm or a standardization body
* Values: string

## commonkeySize

* Description: the detected key size
* Values: bbbb, where bbbb is an integer, provided in bits. One or more values are possible

## specifiedkeySize

* Description: the default key size or range determined by the authors, standardization or compliance bodies/agencies
* Values: any of these options are valid
   * bbbb, where bbbb is an integer, provided in bits. If more than one value is possible, the operator AND will be used
   * bbbb TO cccc, where bbbb and cccc are integers, provided in bits, to express a range

## cryptoClass

* Description: cryptographic algorithms are categorised in classes. The classes are defined by the number of cryptographic keys that are used in conjunction with the algorithm.
   * Cryptographic hash functions do not require keys for their basic operation.
   * Symmetric-key algorithms transform data in a way that is fundamentally difficult to undo without knowledge of a secret key. The key is “symmetric” because the same key is used for a cryptographic operation and its inverse
   * Asymmetric-key algorithms, commonly known as public-key algorithms, use two related keys (i.e., a key pair) to perform their functions: a public key and a private key. The public key may be known by anyone; the private key should be under the sole control of the entity that “owns” the key pair. Even though the public and private keys of a key pair are related, knowledge of the public key cannot be used to determine the private key.
* Values: "Cryptographic-Hash-Function" , "Symetric-Key-Algorithm" or "Asymmetric-Key-Algorithm"

Note: the subclasses has been added to to cryptoClass attribute, separated by a "/" character. This specific point is WIP.
