// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "WinTool-macOS",
    products: [
        .executable(
            name: "WinTool",
            targets: ["wintoolTar"]
            //platforms: [.macOS(.v14)]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/soffes/HotKey", from: "0.2.0")
    ],
    targets: [
        .target(
            name: "wintoolTar",
            dependencies: [
                "HotKey",
                //.target(name: "wintool", condition: .when(platforms: [.macOS]))
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
