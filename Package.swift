// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "ZenUI",
    platforms: [
        .macOS(.v11),
        .iOS(.v14)
    ],
    products: [
        .library(
            name: "ZenUI",
            targets: ["ZenUI"]),
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "ZenUI",
            dependencies: []),
        .testTarget(
            name: "ZenUITests",
            dependencies: ["ZenUI"]),
    ]
)
