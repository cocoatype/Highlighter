import ProjectDescription

extension Target {
    static func capabilitiesTarget(
        name: String,
        sdk: SDK = .catalyst,
        hasResources: Bool = false,
        usesMaxSwiftVersion: Bool = true,
        dependencies: [TargetDependency] = []
    ) -> Target {
        Target.target(
            name: name + sdk.nameSuffix,
            destinations: sdk.destinations,
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
        sdk: SDK = .catalyst,
        hasResources: Bool = false,
        usesMaxSwiftVersion: Bool = false,
        dependencies: [TargetDependency] = []
    ) -> Target {
        moduleTestTarget(
            name: name,
            sdk: sdk,
            type: "Capabilities",
            hasResources: hasResources,
            usesMaxSwiftVersion: usesMaxSwiftVersion,
            dependencies: dependencies
        )
    }

    static func moduleTestTarget(
        name: String,
        sdk: SDK,
        type: String,
        hasResources: Bool = false,
        usesMaxSwiftVersion: Bool = false,
        dependencies: [TargetDependency] = []
    ) -> Target {
        return Target.target(
            name: "\(name + sdk.nameSuffix)Tests",
            destinations: sdk.destinations,
            product: .unitTests,
            bundleId: "com.cocoatype.Highlighter.\(name + sdk.nameSuffix)Tests",
            sources: ["Modules/\(type)/\(name)/Tests/**"],
            resources: hasResources ? ["Modules/\(type)/\(name)/TestResources/**"] : nil,
            dependencies: [.target(name: name + sdk.nameSuffix)] + dependencies,
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
        sdk: SDK = .catalyst
    ) -> Target {
        return Target.target(
            name: "\(name + sdk.nameSuffix)Doubles",
            destinations: sdk.destinations,
            product: .framework,
            bundleId: "com.cocoatype.Highlighter.\(name + sdk.nameSuffix)Doubles",
            sources: ["Modules/Capabilities/\(name)/Doubles/**"],
            dependencies: [
                .target(name: name + sdk.nameSuffix),
                .target(TestHelpers.interfaceTarget),
            ],
            settings: .settings(
                base: [
                    "DERIVE_MACCATALYST_PRODUCT_BUNDLE_IDENTIFIER": false,
                ],
                defaultSettings: .recommended(excluding: [
                    "CODE_SIGN_IDENTITY",
                ])
            )
        )
    }
}
