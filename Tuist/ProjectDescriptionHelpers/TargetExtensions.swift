import ProjectDescription

extension Target {
    static func capabilitiesTarget(
        name: String,
        hasResources: Bool = false,
        supportsNativeMac: Bool = false,
        dependencies: [TargetDependency] = []
    ) -> Target {
        var buildableFolders: [BuildableFolder] = [
            .folder("Modules/Capabilities/\(name)/Sources"),
        ]

        if hasResources {
            buildableFolders.append(.folder("Modules/Capabilities/\(name)/Resources"))
        }

        return Target.target(
            name: name,
            destinations: destinations(supportsNativeMac: supportsNativeMac),
            product: .framework,
            bundleId: "com.cocoatype.Highlighter.\(name)",
            buildableFolders: buildableFolders,
            dependencies: dependencies,
            settings: .settings(
                base: [
                    "DERIVE_MACCATALYST_PRODUCT_BUNDLE_IDENTIFIER": false,
                    "SWIFT_APPROACHABLE_CONCURRENCY": true,
                    "SWIFT_UPCOMING_FEATURE_EXISTENTIAL_ANY": true,
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
        supportsNativeMac: Bool = false,
        dependencies: [TargetDependency] = []
    ) -> Target {
        moduleTestTarget(
            name: name,
            type: "Capabilities",
            hasResources: hasResources,
            supportsNativeMac: supportsNativeMac,
            dependencies: dependencies
        )
    }

    static func moduleTestTarget(
        name: String,
        type: String,
        hasResources: Bool = false,
        supportsNativeMac: Bool = false,
        dependencies: [TargetDependency] = []
    ) -> Target {
        var buildableFolders: [BuildableFolder] = [
            .folder("Modules/\(type)/\(name)/Tests"),
        ]

        if hasResources {
            buildableFolders.append(.folder("Modules/\(type)/\(name)/TestResources"))
        }

        return Target.target(
            name: "\(name)Tests",
            destinations: destinations(supportsNativeMac: supportsNativeMac),
            product: .unitTests,
            bundleId: "com.cocoatype.Highlighter.\(name)Tests",
            buildableFolders: buildableFolders,
            dependencies: [.target(name: name)] + dependencies,
            settings: .settings(
                base: [
                    "SWIFT_APPROACHABLE_CONCURRENCY": true,
                    "SWIFT_UPCOMING_FEATURE_EXISTENTIAL_ANY": true,
                ],
                defaultSettings: .recommended(excluding: [
                    "CODE_SIGN_IDENTITY",
                ])
            )
        )
    }

    static func capabilitiesDoublesTarget(
        name: String,
        supportsNativeMac: Bool = false,
        dependencies: [TargetDependency] = [],
    ) -> Target {
        return Target.target(
            name: "\(name)Doubles",
            destinations: destinations(supportsNativeMac: supportsNativeMac),
            product: .framework,
            bundleId: "com.cocoatype.Highlighter.\(name)Doubles",
            buildableFolders: [.folder("Modules/Capabilities/\(name)/Doubles")],
            dependencies: [
                .target(name: name),
            ] + dependencies,
            settings: .settings(
                base: [
                    "DERIVE_MACCATALYST_PRODUCT_BUNDLE_IDENTIFIER": false,
                    "SWIFT_APPROACHABLE_CONCURRENCY": true,
                    "SWIFT_UPCOMING_FEATURE_EXISTENTIAL_ANY": true,
                ],
                defaultSettings: .recommended(excluding: [
                    "CODE_SIGN_IDENTITY",
                ])
            )
        )
    }

    private static func destinations(
        supportsNativeMac: Bool,
    ) -> Set<Destination> {
        var destinations: Set<Destination> = [.iPhone, .iPad, .macCatalyst, .appleVisionWithiPadDesign]

        if supportsNativeMac {
            destinations.insert(.mac)
        }

        return destinations
    }
}
