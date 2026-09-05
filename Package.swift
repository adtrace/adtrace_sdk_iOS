// swift-tools-version:5.5

import PackageDescription

let package = Package(
    name: "Adtrace",
    platforms: [
        .iOS(.v12),
        .tvOS(.v12)
    ],
    products: [
        .library(name: "Adtrace", targets: ["Adtrace"]),
        .library(name: "WebBridge", targets: ["WebBridge", "Adtrace"])
    ],
    targets: [
        .target(
            name: "Adtrace",
            path: "Adtrace",
            exclude: [
                "Info.plist",
                "include"
            ],
            resources: [
                .copy("PrivacyInfo.xcprivacy")
            ],
            cSettings: [
                .headerSearchPath(""),
                .headerSearchPath("ADTAdditions")
            ]
        ),
        .target(
            name: "WebBridge",
            path: "AdtraceBridge",
            exclude: ["Adtrace"],
            cSettings: [
                .headerSearchPath(""),
                .headerSearchPath("WebViewJavascriptBridge"),
                .headerSearchPath("Adtrace"),
            ]
        ),
    ]
)
