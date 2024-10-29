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
        .plugin(name: "SwiftLint", targets: ["SwiftLint"]),
    ],
    dependencies: [
        .package(url: "https://github.com/justin/jww-xctest-extensions.git", branch: "main")
    ],
    targets: [
        .target(
            name: "JWWNetworking",
            plugins: [
                .plugin(name: "SwiftLint")
            ]),

        .testTarget(
            name: "JWWNetworkingTests",
            dependencies: [
                "JWWNetworking",
                .product(name: "JWWTestExtensions", package: "jww-xctest-extensions")
            ]),
        .binaryTarget(
            name: "SwiftLintBinary",
            url: "https://github.com/realm/SwiftLint/releases/download/0.57.0/SwiftLintBinary-macos.artifactbundle.zip",
            checksum: "a1bbafe57538077f3abe4cfb004b0464dcd87e8c23611a2153c675574b858b3a"),

        .plugin(
            name: "SwiftLint",
            capability: .buildTool(),
            dependencies: ["SwiftLintBinary"]),
    ]
)
