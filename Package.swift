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
	.package(name: "NavigationStack", url: "https://github.com/matteopuc/swiftui-navigation-stack.git", from: "1.0.2")
    ],
    targets: [
        .target(
            name: "ZenUI",
            dependencies: ["NavigationStack"]),
        .testTarget(
            name: "ZenUITests",
            dependencies: ["ZenUI"]),
    ]
)
