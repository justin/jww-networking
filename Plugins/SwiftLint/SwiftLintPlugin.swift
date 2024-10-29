import Foundation
import PackagePlugin

/// Build plugin that runs SwiftLint against the package's .swiftlint.yml file.
@main
struct SwiftLintPlugin: BuildToolPlugin {
    func createBuildCommands(context: PluginContext, target: Target) async throws -> [Command] {
        return [
            .buildCommand(
                displayName: "SwiftLint",
                executable: try context.tool(named: "swiftlint").url,
                arguments: [
                    "lint",
                    "--cache-path",
                    "\(context.pluginWorkDirectoryURL)"
                ],
                environment: [:]
            )
        ]
    }
}

#if canImport(XcodeProjectPlugin)
import XcodeProjectPlugin

extension SwiftLintPlugin: XcodeBuildToolPlugin {
    func createBuildCommands(
        context: XcodePluginContext,
        target: XcodeTarget
    ) throws -> [Command] {
        return [
            .buildCommand(
                displayName: "SwiftLint",
                executable: try context.tool(named: "swiftlint").url,
                arguments: [
                    "lint",
                    "--cache-path", "\(context.pluginWorkDirectoryURL)"
                ]
            )
        ]
    }
}
#endif
