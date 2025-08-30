import ProjectDescription

extension Target {
    static func capabilitiesTarget(
        name: String,
        hasResources: Bool = false,
        usesMaxSwiftVersion: Bool = true,
        dependencies: [TargetDependency] = []
    ) -> Target {
        Target.target(
            name: name,
            destinations: [.iPhone, .iPad, .macCatalyst, .appleVisionWithiPadDesign],
            product: .framework,
            bundleId: "com.cocoatype.Highlighter.\(name)",
            sources: ["Modules/Capabilities/\(name)/Sources/**"],
            resources: hasResources ? ["Modules/Capabilities/\(name)/Resources/**"] : nil,
            dependencies: dependencies,
            settings: .settings(
                base: [
                    "DERIVE_MACCATALYST_PRODUCT_BUNDLE_IDENTIFIER": false,
                    "SWIFT_VERSION": (usesMaxSwiftVersion ? "$(SWIFT_MAX_VERSION)" : "$(inherited)"),
                ],
                defaultSettings: .recommended(excluding: [
                    "CODE_SIGN_IDENTITY",
                ])
            )
        )
    }

    static func capabilitiesTestTarget(
        name: String,
        hasResources: Bool = false,
        usesMaxSwiftVersion: Bool = true,
        dependencies: [TargetDependency] = []
    ) -> Target {
        moduleTestTarget(
            name: name,
            type: "Capabilities",
            hasResources: hasResources,
            usesMaxSwiftVersion: usesMaxSwiftVersion,
            dependencies: dependencies
        )
    }

    static func moduleTestTarget(
        name: String,
        type: String,
        hasResources: Bool = false,
        usesMaxSwiftVersion: Bool = true,
        dependencies: [TargetDependency] = []
    ) -> Target {
        return Target.target(
            name: "\(name)Tests",
            destinations: [.iPhone, .iPad, .macCatalyst, .appleVisionWithiPadDesign],
            product: .unitTests,
            bundleId: "com.cocoatype.Highlighter.\(name)Tests",
            sources: ["Modules/\(type)/\(name)/Tests/**"],
            resources: hasResources ? ["Modules/\(type)/\(name)/TestResources/**"] : nil,
            dependencies: [.target(name: name)] + dependencies,
            settings: .settings(
                base: [
                    "SWIFT_VERSION": (usesMaxSwiftVersion ? "$(SWIFT_MAX_VERSION)" : "$(inherited)"),
                ],
                defaultSettings: .recommended(excluding: [
                    "CODE_SIGN_IDENTITY",
                ])
            )
        )
    }

    static func capabilitiesDoublesTarget(
        name: String,
        usesMaxSwiftVersion: Bool = true
    ) -> Target {
        return Target.target(
            name: "\(name)Doubles",
            destinations: [.iPhone, .iPad, .macCatalyst, .appleVisionWithiPadDesign],
            product: .framework,
            bundleId: "com.cocoatype.Highlighter.\(name)Doubles",
            sources: ["Modules/Capabilities/\(name)/Doubles/**"],
            dependencies: [
                .target(name: name),
                .target(TestHelpers.interfaceTarget),
            ],
            settings: .settings(
                base: [
                    "DERIVE_MACCATALYST_PRODUCT_BUNDLE_IDENTIFIER": false,
                    "SWIFT_VERSION": (usesMaxSwiftVersion ? "$(SWIFT_MAX_VERSION)" : "$(inherited)"),
                ],
                defaultSettings: .recommended(excluding: [
                    "CODE_SIGN_IDENTITY",
                ])
            )
        )
    }
}
