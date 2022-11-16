// swift-tools-version: 5.7

import PackageDescription

let package = Package(
    name: "JWW Networking",
    platforms: [
        .iOS(.v15),
        .macOS(.v12)
    ],
    products: [
        .library(name: "JWWNetworking", targets: ["JWWNetworking"]),
        .plugin(name: "SwiftLint", targets: ["SwiftLint"]),
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "JWWNetworking",
            plugins: [
                .plugin(name: "SwiftLint")
            ]),

        .testTarget(
            name: "JWWNetworkingTests",
            dependencies: ["JWWNetworking"]),

        .binaryTarget(
            name: "SwiftLintBinary",
            url: "https://github.com/realm/SwiftLint/releases/download/0.49.1/SwiftLintBinary-macos.artifactbundle.zip",
            checksum: "227258fdb2f920f8ce90d4f08d019e1b0db5a4ad2090afa012fd7c2c91716df3"),

        .plugin(
            name: "SwiftLint",
            capability: .buildTool(),
            dependencies: ["SwiftLintBinary"]),
    ]
)
