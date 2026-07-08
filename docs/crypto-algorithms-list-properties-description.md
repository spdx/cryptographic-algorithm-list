# SPDX Cryptographic Algorithms List properties description

## id

* Description: unique identifier for every cryptographic algorithm. This list provides an identifier per algorithm.
* Cardinality: [1]
* Values: string, where the usage of lower or upper case characters depend on each algorithm

## oid

* Description: unique, globally unambiguous identifier, managed by registration authorities to ensure it clearly identifies a specific object, such as a cryptographic algorithm
* Cardinality:  [0..*]
* Values: series of integers separated by dots, where each number represents a level in a tree structure

## name

* Description: widely accepted name provided by the author of the algorithm or a standardization body
* Cardinality: [1]
* Values: string

## commonkeySize

* Description: the detected key size
* Cardinality: [0..*]
* Values:
  * <integer>, where <integer> is an integer, provided in bits.
  * ['<integer1>','<integer2>', ... '<integerx>'], where <integer2>, <integer2>, ... <integerx> are different integers, provided in bits, and in ascendant order.

## specifiedkeySize

* Description: the default key size or range determined by the authors of the algorithm, standardization or compliance bodies/agencies
* Cardinality: [0..*]
* Values: one of these options, or a combination of them, are valid
   * <integer>, where <integer> is an integer, provided in bits.
   * ['<integer1>','<integer2>', ... '<integerx>'], where <integer2>, <integer2>, ... <integerx> are different integers, provided in bits, and in ascendant order.
   * {min: '<intergermin>', max: '<intergermax>'}, where <integermin> is the minimum integer, and <integermax> is the maximum integer of the range, both provided in bits.

## cryptoClass

* Description: cryptographic algorithms are categorized in classes. The classes are defined by the number of cryptographic keys that are used in conjunction with the algorithm, their functional nature, or their resistance to specific computational threats.
   * Cryptographic-Hash-Function: cryptographic hash functions do not require keys for their basic operation.
   * Symmetric-Key-Algorithm: symmetric-key algorithms transform data in a way that is fundamentally difficult to undo without knowledge of a secret key. The key is “symmetric” because the same key is used for a cryptographic operation and its inverse.
   * Asymmetric-Key-Algorithm: asymmetric-key algorithms, commonly known as public-key algorithms, use two related keys (i.e., a key pair) to perform their functions: a public key and a private key. The public key may be known by anyone; the private key should be under the sole control of the entity that “owns” the key pair. Even though the public and private keys of a key pair are related, knowledge of the public key cannot be used to determine the private key.
   * Message-Authentication-Code: these algorithms provide data origin authentication and integrity protection by requiring a shared secret key between the sender and receiver to generate a tag. Unlike simple hash functions, they ensure that a message cannot be tampered with by an attacker who does not possess the secret key.
   * Key-Derivation-Function: these functions derive one or more secret keys from a master secret, password, or other entropy source through a process of stretching or compression. They are essential for transforming human-readable passwords or raw keying material into secure, fixed-length keys suitable for other cryptographic operations.
   * Random-Number-Generator: these mechanisms produce sequences of bits or numbers that lack any predictable pattern and are used to ensure the unpredictability of cryptographic keys and nonce. They include both hardware-based true random number generators and deterministic algorithms that expand a small entropy seed into a larger sequence.
* Cardinality: [1]
* Values: "Cryptographic-Hash-Function", "Symmetric-Key-Algorithm", "Asymmetric-Key-Algorithm", "Message-Authentication-Code", "Key-Derivation-Function", or "Random-Number-Generator"

### cryptoSubClass

* Description: each class of algorithms is categorised in subclasses.
* Cardinality: [0..1]
* Values:
   * cryptoClass "Cryptographic-Hash-Function"
     * cryptoSubClass values: "Hash-Function" , "Password-Hashing" or "Checksum"
  * cryptoClass "Symetric-Key-Algorithm"
     * cryptoSubClass values: "Block-Cipher" , "Stream-Cipher" or "Encoding"
  * cryptoClass "Asymmetric-Key-Algorithm"
     * cryptoSubClass values: "Public-Key-Encryption" , "Public-Key-Cipher" , "Elliptic-Curve-Cryptography" , "Digital-Signature" , "Protocol", "Hybrid-Cipher" or "Key-Exchange-Mechanism"
  * cryptoClass "Message-Authentication-Code"
     * cryptoSubClass values:
  * cryptoClass "Key-Derivation-Function"
     * cryptoSubClass values:
  * cryptoClass "Random-Number-Generator"
     * cryptoSubClass values:

Notes: 
1. the subclasses has been added to the cryptoClass property, separated by a "/" character from the class. This specific way to structure the subclasses is WIP.
2. cryptoSubClass values are currently WIP

## reference

* Description: A link or reference to the authoritative publication, standard, or technical specification that formally defines the cryptographic algorithm. This resource MUST provide details on the algorithm’s mathematical basis, rationale, intended applications, and implementation considerations.
* Cardinality: [1..*]
* Value: Array of strings (each string must be a valid URL)
   * Each reference should be placed on a different line, as a list.
   * Ordering and Prioritization Rules:
      * Highest priority: Official specification published by a recognized standardization body (e.g., NIST, IETF, ISO/IEC, ANSI, ETSI, RFC series, etc.).
      * Next priority: Original research paper or technical report published by the algorithm designers/authors.
      * Next priority: Any other authoritative, publicly accessible and free of charge document that provide the required detail about the algorithm.
      * Additional references (optional): Any other authoritative documents that provide the required detail about the algorithm.
