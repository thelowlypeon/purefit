# PureFIT

PureFIT is a super simple FIT file parsing library written entirely in Swift.

## Why?

Other FIT parsing libraries in Swift/Objc are great for showing known values (eg, find the heartRate reading in each record message),
but none allow showing _all_ values, known or unknown. For example, the [Garmin fit-objective-c-sdk](https://github.com/garmin/fit-objective-c-sdk)
will only show messages that have a known global message number, and lumps the rest into an invalid UInt16 value.
(The garmin library also requires a file URL for streaming the file, which is slow if you have an instance of `Data` to parse.)

## Desgin

PureFIT aims to provide a Swift-friendly representation of a FIT file, which is not necessarily the most useful representation
if you want to, for example, get a speed `Measurement<UnitSpeed>` for each record message.
(It would be easy, though, to extend this to do so.)

## Usage

Simply pass your `Data` instance into `PureFIT.FITFile(data: data)`:

```swift
let fitFileURL = URL(...)!
let data = try Data(contentsOf: url)
if let fitFile = FITFile(data: data) {
  let protocolVersion = fitFile.header.protocolVersion
  //...
}
```

### CRC Validation

By default, CRCs (both header and file) are validated if they are present, and if they are absent, parsing works fine.
Optionally pass in `validationMethod: .requireValidCRC` to raise if the CRC is invalid or not present,
or `validationMethod: .skipCRCValidation` if you want to skip CRC validation entirely.

You can manually validate the CRC with `fitFile.isHeaderCRCValid(fileData: data)` or `fitFile.isCRCValid(fileData: data)` if you skip during parsing.
Note that the data passed in to either of these functions must be the entire file data, not the header or record message slice; this data is not retained after parsing.

## Contribution guidelines

Feel free to fork and pull request, or create an issue if something isn't working right.
