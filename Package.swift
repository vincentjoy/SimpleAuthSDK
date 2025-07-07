// swift-tools-version: 5.7
import PackageDescription

let package = Package(
    name: "SimpleAuthSDK",
    platforms: [
        .iOS(.v13),
        .macOS(.v10_15),
        .watchOS(.v6),
        .tvOS(.v13)
    ],
    products: [
        .library(
            name: "SimpleAuthSDK",
            targets: ["SimpleAuthSDK"]),
    ],
    dependencies: [
        // LoggerSDK dependency
        .package(url: "https://github.com/vincentjoy/LoggerSDK.git", from: "1.0.1")
    ],
    targets: [
        .target(
            name: "SimpleAuthSDK",
            dependencies: [
                .product(name: "LoggerSDK", package: "loggersdk")
            ]),
        .testTarget(
            name: "SimpleAuthSDKTests",
            dependencies: [
                "SimpleAuthSDK",
                .product(name: "LoggerSDK", package: "loggersdk")
            ]),
    ]
)
