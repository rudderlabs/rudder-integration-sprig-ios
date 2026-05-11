// swift-tools-version: 5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Rudder-Sprig",
    platforms: [
        .iOS("15.0")
    ],
    products: [
        .library(
            name: "Rudder-Sprig",
            targets: ["Rudder-Sprig"]),
    ],
    dependencies: [
        .package(name: "UserLeapKit", url: "https://github.com/UserLeap/userleap-ios-sdk-releases", .upToNextMajor(from: "4.29.0")),
        .package(name: "Rudder", url: "https://github.com/rudderlabs/rudder-sdk-ios", "1.29.0"..<"2.0.0")
    ],
    targets: [
        .target(
            name: "Rudder-Sprig",
            dependencies: [
                .product(name: "UserLeapKit", package: "UserLeapKit"),
                .product(name: "Rudder", package: "Rudder"),
            ],
            path: "Rudder-Sprig",
            sources: ["Classes/"],
            publicHeadersPath: "Classes/",
            cSettings: [
                .headerSearchPath("Classes/")
            ]
        )
    ]
)
