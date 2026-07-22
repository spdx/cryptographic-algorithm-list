# SPDX Cryptographic Algorithms List properties and parameters description

* Property: An intrinsic, static characteristic of the algorithm itself
* Parameter: operational or configuration element that affects how an algorithm is used

## Cryptographic Algorithms properties description

### id

* Description: unique identifier for every cryptographic algorithm. This list provides an identifier per algorithm.
* Cardinality: [1]
* Values: string, where the usage of lower or upper case characters depend on each algorithm

### oid

* Description: unique, globally unambiguous identifier, managed by registration authorities to ensure it clearly identifies a specific object, such as a cryptographic algorithm
* Cardinality:  [0..*]
* Values: series of integers separated by dots, where each number represents a level in a tree structure

### name

* Description: widely accepted name provided by the author of the algorithm or a standardization body
* Cardinality: [1]
* Values: string

### commonkeySize

* Description: the detected key size
* Cardinality: [0..*]
* Values:
  * '<integer>', where <integer> is an integer, provided in bits, as a quoted string.
  * ['<integer1>','<integer2>', ... '<integerx>'], where <integer2>, <integer2>, ... <integerx> are different integers, provided in bits, and in ascendant order.

### specifiedkeySize

* Description: the default key size or range determined by the authors of the algorithm, standardization or compliance bodies/agencies
* Cardinality: [0..*]
* Values: one of these options, or a combination of them, are valid
   * '<integer>', where <integer> is an integer, provided in bits, as a quoted string.
   * ['<integer1>','<integer2>', ... '<integerx>'], where <integer2>, <integer2>, ... <integerx> are different integers, provided in bits, and in ascendant order.
   * {min: '<integermin>', max: '<intergermax>'}, where <integermin> is the minimum integer, and <integermax> is the maximum integer of the range, both provided in bits.

### cryptoClass

* Description: cryptographic algorithms are categorized in classes. The classes are defined by the number of cryptographic keys that are used in conjunction with the algorithm, their functional nature, or their resistance to specific computational threats.
   * Cryptographic-Hash-Function: cryptographic hash functions do not require keys for their basic operation.
   * Symmetric-Key-Algorithm: symmetric-key algorithms transform data in a way that is fundamentally difficult to undo without knowledge of a secret key. The key is "symmetric" because the same key is used for a cryptographic operation and its inverse.
   * Asymmetric-Key-Algorithm: asymmetric-key algorithms, commonly known as public-key algorithms, use two related keys (i.e., a key pair) to perform their functions: a public key and a private key. The public key may be known by anyone; the private key should be under the sole control of the entity that "owns" the key pair. Even though the public and private keys of a key pair are related, knowledge of the public key cannot be used to determine the private key.
   * Message-Authentication-Code: these algorithms provide data origin authentication and integrity protection by requiring a shared secret key between the sender and receiver to generate a tag. Unlike simple hash functions, they ensure that a message cannot be tampered with by an attacker who does not possess the secret key.
   * Key-Derivation-Function: these functions derive one or more secret keys from a master secret, password, or other entropy source through a process of stretching or compression. They are essential for transforming human-readable passwords or raw keying material into secure, fixed-length keys suitable for other cryptographic operations.
   * Random-Number-Generator: these mechanisms produce sequences of bits or numbers that lack any predictable pattern and are used to ensure the unpredictability of cryptographic keys and nonce. They include both hardware-based true random number generators and deterministic algorithms that expand a small entropy seed into a larger sequence.
* Cardinality: [1]
* Values: "Cryptographic-Hash-Function", "Symmetric-Key-Algorithm", "Asymmetric-Key-Algorithm", "Message-Authentication-Code", "Key-Derivation-Function", or "Random-Number-Generator"

#### cryptoSubClass

* Description: each class of algorithms is categorised in subclasses.
* Cardinality: [0..1]
* Values:
   * cryptoClass "Cryptographic-Hash-Function"
     * cryptoSubClass values: "Hash-Function" , "Password-Hashing" or "Checksum"
  * cryptoClass "Symmetric-Key-Algorithm"
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

### reference

* Description: A link or reference to the authoritative publication, standard, or technical specification that formally defines the cryptographic algorithm. This resource MUST provide details on the algorithm's mathematical basis, rationale, intended applications, and implementation considerations.
* Cardinality: [1..*]
* Value: Array of strings (each string must be a valid URL)
   * Each reference should be placed on a different line, as a list.
   * Ordering and Prioritization Rules:
      * Highest priority: Official specification published by a recognized standardization body (e.g., NIST, IETF, ISO/IEC, ANSI, ETSI, RFC series, etc.).
      * Next priority: Original research paper or technical report published by the algorithm designers/authors.
      * Next priority: Any other authoritative, publicly accessible and free of charge document that provide the required detail about the algorithm.
      * Additional references (optional): Any other authoritative documents that provide the required detail about the algorithm.

## Cryptographic Algorithms parameters description

### parameterName

* Description: The set of valid values depends on the algorithm's cryptoClass / cryptoSubClass. Each parameter have a different structure so their description is specific to each one of them
* Cardinality: [0..*]
* Values:
   * Enumeration: "operationMode", "padding", "paddingScheme", "digestFunction", "variant", "construction", "pseudorandomFunction", "group", "curve", "pointCompression", "polynomial", "underlyingCipher"
    * Numeric: "nonceLength", "ivLength", "tagLength", "keyLength", "outputLength", "saltLength", "modulusLength", "pPrimeLength", "qPrimeLength", "publicExponent", "iterations", "memoryCost", "parallelism", "costFactor", "rounds", "dropBytes"

### operationMode

* Description: the mode of operation under which a block cipher is applied to data. Modes are standardised constructions that compose the cipher's primitive transformation into a complete encryption scheme over arbitrary-length input.
   * GCM: Galois/Counter Mode
      * NIST SP 800-38D: https://csrc.nist.gov/pubs/sp/800/38/d/final
   * CCM: Counter with CBC-MAC
      * NIST SP 800-38C: https://csrc.nist.gov/pubs/sp/800/38/c/upd1/final
   * CBC: Cipher Block Chaining
      * NIST SP 800-38A: https://csrc.nist.gov/pubs/sp/800/38/a/final
   * CTR: Counter Mode
      * NIST SP 800-38A: https://csrc.nist.gov/pubs/sp/800/38/a/final
   * OFB: Output Feedback Mode
      * NIST SP 800-38A: https://csrc.nist.gov/pubs/sp/800/38/a/final
   * CFB: Cipher Feedback Mode
      * CFB1: NIST SP 800-38A (s = 1 bit): https://csrc.nist.gov/pubs/sp/800/38/a/final
      * CFB8: NIST SP 800-38A (s = 8 bits): https://csrc.nist.gov/pubs/sp/800/38/a/final
      * CFB128: NIST SP 800-38A (s = 128 bits): https://csrc.nist.gov/pubs/sp/800/38/a/final
   * XTS: XEX-based Tweaked Cipher Mode with ciphertext stealing
      * NIST SP 800-38E: https://csrc.nist.gov/pubs/sp/800/38/e/final
   * SIV: Synthetic Initialization Vector
      * RFC 5297: https://datatracker.ietf.org/doc/html/rfc5297
   * GCM-SIV: GCM with Synthetic IV
      * RFC 8452: https://datatracker.ietf.org/doc/html/rfc8452
   * EAX: Encrypt-then-Authenticate-then-Translate Mode
      * ISO/IEC 19772; Bellare, Rogaway, Wagner (FSE 2004): https://web.cs.ucdavis.edu/~rogaway/papers/eax.pdf
   * OCB: Offset Codebook Mode
      * OCB2: ISO/IEC 19772:2009: https://www.iso.org/standard/46345.html
      * OCB3: RFC 7253: https://datatracker.ietf.org/doc/html/rfc7253
   * CTS: Ciphertext Stealing
      * CBC-CS1: NIST SP 800-38A Addendum: https://csrc.nist.gov/pubs/sp/800/38/a/add/final
      * CBC-CS2: NIST SP 800-38A Addendum: https://csrc.nist.gov/pubs/sp/800/38/a/add/final
      * CBC-CS3: NIST SP 800-38A Addendum: https://csrc.nist.gov/pubs/sp/800/38/a/add/final
   * CWC: Carter-Wegman Counter Mode
      * Kohno, Viega, Whiting (FSE 2004): https://eprint.iacr.org/2003/106
   * IAPM: Integrity-Aware Parallelizable Mode
      * Jutla (EUROCRYPT 2001): https://eprint.iacr.org/2000/039
   * LRW: Liskov-Rivest-Wagner Mode
      * Liskov, Rivest, Wagner (CRYPTO 2002): https://people.csail.mit.edu/rivest/pubs/LRW02.pdf
   * XEX: XOR-Encrypt-XOR Mode
      * Rogaway (ASIACRYPT 2004): https://www.cs.ucdavis.edu/~rogaway/papers/offsets.pdf
   * CMC: CBC-Mask-CBC Mode
      * Halevi, Rogaway (CRYPTO 2003): https://eprint.iacr.org/2003/148
   * EME: Encrypt-Mix-Encrypt Mode
      * Halevi, Rogaway (CT-RSA 2004): https://eprint.iacr.org/2003/147
   * HCTR2: Length-Preserving Encryption with HCTR2
      * Crowley, Huckleberry, Biggers (IACR ePrint 2021/1441): https://eprint.iacr.org/2021/1441
   * CMAC: Cipher-based MAC
      * NIST SP 800-38B: https://csrc.nist.gov/pubs/sp/800/38/b/upd1/final
   * GMAC: Galois MAC
      * NIST SP 800-38D: https://csrc.nist.gov/pubs/sp/800/38/d/final
   * PMAC: Parallelizable MAC
      * Black, Rogaway (EUROCRYPT 2002): https://www.cs.ucdavis.edu/~rogaway/papers/pmac.pdf
   * PCBC: Propagating CBC
      * No formal standard; used in Kerberos v4 (see RFC 1510, historical): https://www.rfc-editor.org/info/rfc1510/
   * IGE: Infinite Garble Extension
      * No formal standard; first described by Campbell (1978); used in Telegram MTProto: https://core.telegram.org/mtproto/description. Check Ben Laurie description on openSSL-IGE https://www.links.org/files/openssl-ige.pdf
   * ECB: Electronic Codebook
      * NIST SP 800-38A: https://csrc.nist.gov/pubs/sp/800/38/a/final
   * FF1: Format-Preserving Encryption method 1
      * NIST SP 800-38G: https://csrc.nist.gov/pubs/sp/800/38/g/upd1/final
   * FF3: Format-Preserving Encryption method 3 (original)
      * NIST SP 800-38G (withdrawn 2016, superseded by FF3-1-draft after Durak-Vaudenay attack): https://csrc.nist.gov/pubs/sp/800/38/g/final
   * FF3-1: Format-Preserving Encryption method 3, revised
      * NIST SP 800-38G Revision 1 (draft): https://csrc.nist.gov/pubs/sp/800/38/g/r1/2pd
   * Wrap: Key Wrap
      * KW: NIST SP 800-38F: https://csrc.nist.gov/pubs/sp/800/38/f/final
      * KWP: NIST SP 800-38F: https://csrc.nist.gov/pubs/sp/800/38/f/final
      * TKW: NIST SP 800-38F (TDEA-based, legacy applications): https://csrc.nist.gov/pubs/sp/800/38/f/final
   * XCBC_MAC: XCBC Message Authentication Code (Black, Rogaway, CRYPTO 2000)
      * XCBC_MAC: full-length construction: https://www.cs.ucdavis.edu/~rogaway/papers/3k.pdf
      * XCBC_MAC_96: truncated to 96 bits, RFC 3566: https://datatracker.ietf.org/doc/html/rfc3566
* Applicability: determines which security service the construction provides (confidentiality only, authenticated encryption, AEAD, or key wrapping) and what auxiliary inputs the scheme requires (initialisation vector, nonce, authentication tag, padding). A given mode is only meaningful for a block cipher of a compatible block size.
* Cardinality: [1..*]
* Values: "GCM", "CCM", "CBC", "CTR", "OFB", "CFB", "CFB1", "CFB8", "CFB128", "XTS", "SIV", "GCM-SIV", "EAX", "OCB", "OCB2", "OCB3", "CTS", "CBC-CS1", "CBC-CS2", "CBC-CS3", "CWC", "IAPM", "LRW", "XEX", "CMC", "EME", "HCTR2", "CMAC", "GMAC", "PMAC", "PCBC", "IGE", "ECB", "FF1", "FF3", "FF3-1", "Wrap", "KW", "KWP", "TKW", "XCBC_MAC", "XCBC_MAC_96"

### keyLength

* Description: the key length, or set of key lengths, that an implementation of the algorithm may be configured with, expressed in bits.
* Applicability: states which key sizes are actually selectable when the algorithm is used, as opposed to a single nominal size. This is distinct from the property-level `commonkeySize` (the key size most often detected in real-world use) and `specifiedkeySize` (the default size or range defined by the algorithm's authors or a standardization body): those are static properties of the algorithm as published, while `keyLength` is a parameter describing a configurable choice at the point the algorithm is instantiated.
* Cardinality: [0..1]
* Values: one of these options, or a combination of them, are valid
   * '<integer>', where <integer> is an integer, provided in bits, as a quoted string.
   * ['<integer1>','<integer2>', ... '<integerx>'], where <integer1>, <integer2>, ... <integerx> are different integers, provided in bits, and in ascendant order.
   * {min: '<intergermin>', max: '<intergermax>'}, where <integermin> is the minimum integer, and <integermax> is the maximum integer of the range, both provided in bits.
