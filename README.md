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
If you want to, for example, get a speed `Measurement<UnitSpeed>` for each record message.
(It would be easy, though, to extend this to do so.)

One of the primary aims of this library is to ensure future-proof-ness as the FIT profile evolves and new fields are added.
As such, this library tries to understand as little about the FIT profile as possible, such as which global message numbers
correspond with which message types, which field numbers correspond to which fields, etc.
Broadly speaking, it knows only what is defined in the FIT file.

### FIT Profile Types

While the aim of this library is to _not_ depend on the FIT profile, ie the _meaning_ of various values,
there are some practical exceptions to make it more useful.

* `FITBaseType`, an enum, defines the type of data for a given field, eg, `.uint8`, or `.enum`
* `FITValue` is derived by `FITBaseType`, and is vastly more useful than dealing with raw bytes. The raw byte array remains available in a `RawFITFile`'s `RawFITRecord`

## Usage

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
