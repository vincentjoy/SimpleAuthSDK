// swift-tools-version: 5.7
import PackageDescription

let package = Package(
    name: "SimpleAuthSDK",
    platforms: [
        .iOS(.v15),
        .macOS(.v12),
        .watchOS(.v8),
        .tvOS(.v15)
    ],
    products: [
        .library(
            name: "SimpleAuthSDK",
            targets: ["SimpleAuthSDK"]),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "SimpleAuthSDK",
            dependencies: []),
        .testTarget(
            name: "SimpleAuthSDKTests",
            dependencies: ["SimpleAuthSDK"]),
    ]
)
