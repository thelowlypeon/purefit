# PureFIT

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
let fit = PureFITFile(url: url)
let recordMessages = fit.messages.compactMap { $0 as? RecordMessage }
let powerFieldValues = recordMessages.map { $0.standardFieldValue(for: .power) as? PowerField.Value }
let powerValues = powerFieldValues.map { $0?.measurement.converted(to: .watts).value }
```

### Unrecognized values

This is the main reason this library exists! Many FIT files written by Garmin or third parties include fields that are not included
in the official FIT Profile. As a result, many fields disappear when sharing from one service to another.
This API is intended to show you what is in the FIT file _even if_ you aren't sure what the field represents (yet).

```swift
let fit = PureFITFile(url: url)
let developerFieldDefinitions = fit.developerFields
for message in fit.messages {
  for (fieldDefinitionNumber, values) in message.fields {
    if let fieldDefinition = message.fieldDefinition(for: fieldDefinitionNumber, developerFieldDefinitions: developerFieldDefinitions) {
      print("\(fieldDefinition.name)": \(fieldDefinition.format(values: values))"
    } else {
      print("Unrecognized field \(fieldDefinitionNumber): \(values")
    }
  }
}
```

### Field Definitions

PureFIT reads developer field definitions from the message, and includes some standard definitions out of the box.
More standard field definitions are on the way.

```swift
let fit = PureFITFile(url: url)
let developerFields = fit.developerFields
if let speed = developerFields[.developer(0, 5)] {
  print(speed.name) // "Speed"
  print(speed.baseType) // .float32
  print(speed.scale) // 1.0
  print(speed.offset) // 0.0
  print(speed.units) // "M/S"
  print(speed.nativeMessageNumber) // 5
  
  // use the field definition to parse raw FIT values
  print(speed.parse(.float32(123)?.format(locale: .current)) // 123.0 M/S
}
```

### FIT Details

Simply pass your `Data` instance into `RawFITFile(data: data)`:

```swift
let fitFileURL = URL(...)!
if let rawFitFile = RawFITFile(url: url) {
  let protocolVersion = rawFitFile.header.protocolVersion
  //...
}

// or from Data
if let rawFitFile = RawFITFile(data: data) {
  //...
```

### CRC Validation

By default, CRCs (both header and file) are validated if they are present, and if they are absent, parsing works fine.
Optionally pass in `validationMethod: .requireValidCRC` to raise if the CRC is invalid or not present,
or `validationMethod: .skipCRCValidation` if you want to skip CRC validation entirely.

You can manually validate the CRC with `fitFile.isHeaderCRCValid(fileData: data)` or `fitFile.isCRCValid(fileData: data)` if you skip during parsing.
Note that the data passed in to either of these functions must be the entire file data, not the header or record message slice; this data is not retained after parsing.

## Contribution guidelines

Feel free to fork and pull request, or create an issue if something isn't working right.
