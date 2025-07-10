// swift-tools-version: 5.9
import PackageDescription

#if TUIST
import ProjectDescription
import ProjectDescriptionHelpers

let packageSettings = PackageSettings(
    productTypes: [
        "FactoryKit": .framework,
        "TelemetryClient": .framework,
        "TelemetryDeck": .framework,
        "SwiftUIIntrospect": .framework,
    ],
    baseSettings: Shared.settings,
    targetSettings: [
        "FactoryKit": [
            "SWIFT_VERSION": "6.0",
            "UNINSTALLED_PRODUCTS_DIR": "$(TEMP_ROOT)/UninstalledProducts$(EFFECTIVE_PLATFORM_NAME)",
        ],
        "FactoryTesting": [
            "SWIFT_VERSION": "6.0",
        ],
        "TelemetryClient": [
            "UNINSTALLED_PRODUCTS_DIR": "$(TEMP_ROOT)/UninstalledProducts$(EFFECTIVE_PLATFORM_NAME)",
        ],
        "TelemetryDeck": [
            "UNINSTALLED_PRODUCTS_DIR": "$(TEMP_ROOT)/UninstalledProducts$(EFFECTIVE_PLATFORM_NAME)",
        ],
    ]
)
#endif

let package = Package(
    name: "Dependencies",
    dependencies: [
        .package(url: "git@github.com:adamwulf/ClippingBezier.git", from: "1.2.0"),
        .package(url: "git@github.com:hmlongco/Factory.git", from: "2.5.0"),
        .package(url: "https://github.com/siteline/SwiftUI-Introspect.git", from: "1.2.0"),
        .package(url: "git@github.com:TelemetryDeck/SwiftClient.git", from: "2.8.0"),
        .package(url: "git@github.com:nalexn/ViewInspector.git", from: "0.10.0"),
    ]
)
