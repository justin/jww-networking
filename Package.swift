// swift-tools-version:6.0

import PackageDescription

let package = Package(
    name: "JWW Networking",
    platforms: [
        .iOS(.v15),
        .macOS(.v12),
        .visionOS(.v1)
    ],
    products: [
        .library(name: "JWWNetworking", targets: ["JWWNetworking"]),
    ],
    dependencies: [
        .package(url: "https://github.com/justin/jww-standard-lib", from: "1.2.0"),
        .package(url: "https://github.com/justin/jww-xctest-extensions", from: "1.4.0"),
        .package(url: "https://github.com/apple/swift-http-types.git", from: "1.3.0"),
    ],
    targets: [
        .target(
            name: "JWWNetworking",
            dependencies:  [
                .product(name: "HTTPTypes", package: "swift-http-types"),
                .product(name: "JWWCore", package: "jww-standard-lib")
            ]),

        .testTarget(
            name: "JWWNetworkingTests",
            dependencies: [
                "JWWNetworking",
                .product(name: "JWWTestExtensions", package: "jww-xctest-extensions")
            ])
    ]
)
