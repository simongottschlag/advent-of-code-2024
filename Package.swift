// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "aoc24",
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser", from: "1.5.0"),
        .package(path: "./days"),
    ],
    targets: [
        .executableTarget(
            name: "aoc24",
            dependencies: [
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
                .product(name: "days", package: "days"),
            ],
            path: "cli"
        ),
        .testTarget(
            name: "daysTest",
            dependencies: ["days"],
            path: "./tests/days"
        ),
    ]
)
