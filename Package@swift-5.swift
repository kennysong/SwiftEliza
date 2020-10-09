// swift-tools-version:5.0

import PackageDescription

let package = Package(
    name: "SwiftEliza",
    products: [
        .library   (name: "Eliza",     targets: [ "Eliza"     ]),
        .executable(name: "therapist", targets: [ "therapist" ])
    ],
    dependencies: [
    ],
    targets: [
        .target(name: "Eliza",      dependencies: []),
        .target(name: "therapist",  dependencies: [ "Eliza" ])
    ]
)
