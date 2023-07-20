// swift-tools-version: 5.8

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
            url: "https://github.com/realm/SwiftLint/releases/download/0.52.4/SwiftLintBinary-macos.artifactbundle.zip",
            checksum: "8a8095e6235a07d00f34a9e500e7568b359f6f66a249f36d12cd846017a8c6f5"),

        .plugin(
            name: "SwiftLint",
            capability: .buildTool(),
            dependencies: ["SwiftLintBinary"]),
    ]
)
