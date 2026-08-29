// swift-tools-version: 6.0

import PackageDescription
import Foundation

// SwiftPM derives a path dependency's identity from its directory name, not from the name declared
// in its manifest. Hardcoding "purefit" would break for anyone who cloned the repo into a
// differently-named folder, so resolve the parent directory's name the same way SwiftPM does.
let pureFITPackage = URL(fileURLWithPath: #filePath)
    .deletingLastPathComponent()  // Benchmarks
    .deletingLastPathComponent()  // <repo>
    .lastPathComponent
    .lowercased()

let package = Package(
    name: "PureFITBenchmarks",
    platforms: [
        .macOS(.v13),
    ],
    dependencies: [
        .package(path: ".."),
        .package(url: "https://github.com/garmin/fit-objective-c-sdk.git", from: "21.214.0"),
    ],
    targets: [
        .executableTarget(
            name: "PureFITBenchmark",
            dependencies: [
                .product(name: "PureFIT", package: pureFITPackage),
                .product(name: "FIT", package: "fit-objective-c-sdk"),
            ],
            swiftSettings: [.swiftLanguageMode(.v5)]
        ),
    ]
)
