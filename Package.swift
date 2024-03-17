// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "WinTool-macOS",
    platforms: [
		.macOS(.v14)
	],
    products: [
        .executable(
            name: "WinTool",
            targets: ["WinTool"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/orchetect/SettingsAccess", from: "1.4.0"),
        .package(url: "https://github.com/sindresorhus/KeyboardShortcuts", from: "2.0.0"),
    ],
    targets: [
        .executableTarget(
            name: "WinTool",
            dependencies: [
                "SettingsAccess",
                "KeyboardShortcuts",
            ],
            linkerSettings: [
                .unsafeFlags([
                    "-Xlinker", "-sectcreate",
                    "-Xlinker", "__TEXT",
                    "-Xlinker", "__info_plist",
                    "-Xlinker", "Info.plist"
                ])
            ]
        ),
    ]
)

