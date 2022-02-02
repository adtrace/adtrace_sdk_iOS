// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "Adtrace",
    products: [
        .library(name: "Adtrace", targets: ["Adtrace"]),


    ],
    targets: [
        .target(
            name: "Adtrace",
            path: "Adtrace",
            exclude: ["Info.plist"],
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
