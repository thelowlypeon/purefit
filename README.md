# PureFIT

[![Tests](https://github.com/thelowlypeon/purefit/actions/workflows/tests.yml/badge.svg)](https://github.com/thelowlypeon/purefit/actions/workflows/tests.yml)

PureFIT is a super simple FIT file parsing library written entirely in Swift.

## Why?

Other FIT parsing libraries in Swift/Objc are great for showing known values (eg, find the heartRate reading in each record message),
but none allow showing _all_ values, known or unknown. For example, the [Garmin fit-objective-c-sdk](https://github.com/garmin/fit-objective-c-sdk)
will only show messages that have a known global message number, and lumps the rest into an invalid UInt16 value.
(The garmin library also requires a file URL for streaming the file, which is slow if you have an instance of `Data` to parse.)

This library does not handle encoding, but that is a possibility for the future.

## Design

PureFIT aims to provide a Swift-friendly representation of a FIT file, called a `RawFITFile`.
On top of `RawFITFile`, PureFIT can interpret FIT files using Garmin's FIT profile,
but, unlike most other libraries, this assumes that the profile is incomplete.
A `PureFITFile`, therefore, can support unreocognized message types and unrecognized fields by default.

One of the primary aims of this library is to ensure future-proof-ness as the FIT profile evolves and new fields are added.
As such, this library tries to understand as little about the FIT profile as possible, such as which global message numbers
correspond with which message types, which field numbers correspond to which fields, etc.
Broadly speaking, it knows only what is defined in the FIT file.

## Usage

There are three main ways to use this library: reading and manipulating specific values, reading all values (including unrecognized fields), using field definitions.

### Specific Values

If you need a value of a specific kind of message for a specific field, such all record messages' power values:

```swift
let fit = try PureFITFile(url: url)
let recordMessages = fit.messages.compactMap { $0 as? RecordMessage }
let powerFieldValues = recordMessages.map { $0.standardFieldValue(for: .power) as? PowerField.Value }
let powerValues = powerFieldValues.map { $0?.measurement.converted(to: .watts).value }
```

### Unrecognized values

This is the main reason this library exists! Many FIT files written by Garmin or third parties include fields that are not included
in the official FIT Profile. As a result, many fields disappear when sharing from one service to another.
This API is intended to show you what is in the FIT file _even if_ you aren't sure what the field represents (yet).

```swift
let fit = try PureFITFile(url: url)
let developerFieldDefinitions = fit.developerFields
for message in fit.messages {
  for (fieldDefinitionNumber, values) in message.fields {
    if let fieldDefinition = message.fieldDefinition(for: fieldDefinitionNumber, developerFieldDefinitions: developerFieldDefinitions) {
      print("\(fieldDefinition.name): \(fieldDefinition.parse(values: values)?.format(locale: .current) ?? "")")
    } else {
      print("Unrecognized field \(fieldDefinitionNumber): \(values)")
    }
  }
}
```

### Field Definitions

PureFIT reads developer field definitions from the message, and includes some standard definitions out of the box.
More standard field definitions are on the way.

```swift
let fit = try PureFITFile(url: url)
let developerFields = fit.developerFields
if let speed = developerFields[.developer(0, 5)] {
  print(speed.name) // "Speed"
  print(speed.baseType) // .float32
  print(speed.scale) // 1.0
  print(speed.offset) // 0.0
  print(speed.units) // "M/S"
  print(speed.nativeMessageNumber) // 5
  
  // use the field definition to parse raw FIT values
  print(speed.parse(values: [.float32(123)])?.format(locale: .current)) // 123.0 M/S
}
```

### FIT Details

`PureFITFile` also exposes `undefinedDataRecords`: any data records for which no preceding definition record was found, so you can inspect (or count) bytes the parser couldn't attribute to a message.

For lower-level access to the raw FIT structure (header, records, CRC) without interpreting the FIT profile, use `RawFITFile` directly:

```swift
let rawFitFile = try RawFITFile(url: url)
let protocolVersion = rawFitFile.header.protocolVersion
//...

// or from Data
let rawFitFile = try RawFITFile(data: data)
```

### CRC Validation

CRC validation is a `RawFITFile` concern (`PureFITFile` doesn't expose CRC state directly).
By default, CRCs (both header and file) are validated if they are present, and if they are absent, parsing works fine.
Optionally pass in `validationMethod: .requireValidCRC` to raise if the CRC is invalid or not present,
or `validationMethod: .skipCRCValidation` if you want to skip CRC validation entirely.

You can manually validate the CRC with `rawFitFile.isHeaderCRCValid(fileData: data)` or `rawFitFile.isCRCValid(fileData: data)` if you skip during parsing.
Note that the data passed in to either of these functions must be the entire file data, not the header or record message slice; this data is not retained after parsing.

## Tests

Raw decoding (header, definition/data records, CRC) and developer fields are well covered.
14 of 15 profiled message types and every field type but `EnergyField` have coverage.

Known gaps, if you're looking for somewhere to contribute: `EnergyField`,
`PureFITFile.undefinedDataRecords`, and 19 of the ~33 profile enums, which are simple `rawValue`
mappings and low-risk but unverified.

## Benchmarks

Against Garmin's [fit-objective-c-sdk](https://github.com/garmin/fit-objective-c-sdk) 21.214.0,
release build, median of 25 runs on an M-series Mac, parsing a 609 KB file of 11,389 records:

| Scenario | PureFIT | Garmin SDK |
| --- | --- | --- |
| Parse | 32.6 ms | 40.0 ms |
| Parse + validate CRC | 33.8 ms | 71.4 ms |
| Parse + extract GPS | 37.0 ms | 41.9 ms |
| Parse from `Data` | 31.8 ms | — decodes from a file path only |
| Count messages by type | 32.2 ms | — no equivalent |
| Raw parse (no profile) | 1.9 ms | — no equivalent |

PureFIT was faster on all four test fixtures, by 1.07x to 6.56x. Both libraries decoded identical
record and GPS coordinate counts, which the benchmark asserts on every run.

Two things are worth more than the headline. The CRC gap is an API difference, not a speed one —
Garmin's `checkIntegrity:` is a second pass over the file. And raw parsing at 1.9 ms against 32.6 ms
shows the cost is profile interpretation, not record decoding, if you only need `RawFITFile`.

One machine, four files. Run them yourself, and see [`Benchmarks/`](Benchmarks/) for what CI enforces:

```sh
cd Benchmarks && swift run -c release PureFITBenchmark --all
```

## Contribution guidelines

Pull requests are welcome — GitHub's "Contribute" button forks the repo and sets up the PR for you.
If something isn't working right, open an issue instead.

Tests and benchmarks run on every pull request. PRs from outside collaborators need manual approval
before checks run.

## License

PureFIT is available under the MIT license. See [LICENSE](LICENSE) for details.
