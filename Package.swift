// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "PureFIT",
    products: [
        .library(
            name: "PureFIT",
            targets: ["PureFIT"]),
    ],
    targets: [
        .target(
            name: "PureFIT"),
        .testTarget(
            name: "PureFITTests",
            dependencies: ["PureFIT"],
            resources: [
                .copy("Fixtures")
            ]
        ),
    ]
)
