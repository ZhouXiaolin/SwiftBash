// swift-tools-version:6.2
import PackageDescription

// iOS-app fork of SwiftBash (ZhouXiaolin/ios15):
// - platform floor lowered from iOS 16 to iOS 15
// - SwiftPorts / SwiftScript / SwiftJSCore surfaces removed — the app
//   only needs the bash interpreter + the native coreutils catalog
// - ShellKit pinned to the matching iOS 15 fork

let package = Package(
    name: "SwiftBash",
    platforms: [
        .macOS(.v13),
        .iOS(.v15),
        .tvOS(.v16),
        .watchOS(.v9),
    ],
    products: [
        .library(name: "BashSyntax", targets: ["BashSyntax"]),
        .library(name: "BashInterpreter", targets: ["BashInterpreter"]),
        .library(name: "BashCommandKit", targets: ["BashCommandKit"]),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser",
                 from: "1.3.0"),
        .package(url: "https://github.com/apple/swift-crypto",
                 from: "3.0.0"),
        .package(url: "https://github.com/ZhouXiaolin/ShellKit",
                 branch: "ios15"),
    ],
    targets: [
        .systemLibrary(
            name: "CXattr",
            path: "Sources/CXattr"
        ),
        .target(
            name: "BashSyntax",
            path: "Sources/BashSyntax"
        ),
        .target(
            name: "BashInterpreter",
            dependencies: [
                "BashSyntax",
                .product(name: "ShellKit", package: "ShellKit"),
                .target(name: "CXattr",
                        condition: .when(platforms: [.linux, .android])),
            ],
            path: "Sources/BashInterpreter"
        ),
        .target(
            name: "BashCommandKit",
            dependencies: [
                "BashInterpreter",
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
                .product(name: "Crypto", package: "swift-crypto"),
            ],
            path: "Sources/BashCommandKit",
            exclude: [
                "API/Shell+Sqlite3.swift",
                "API/Shell+SwiftPortsCommands.swift",
            ]
        ),
    ]
)
