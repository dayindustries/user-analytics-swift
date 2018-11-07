// swift-tools-version:4.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "UserAnalytics",
    products: [
        .library(name: "UserAnalytics", targets: ["UserAnalytics"]),
    ],
    targets: [
        .target(
            name: "UserAnalytics",
            dependencies: []),
        .testTarget(
            name: "UserAnalyticsTests",
            dependencies: ["UserAnalytics"]),
    ]
)
