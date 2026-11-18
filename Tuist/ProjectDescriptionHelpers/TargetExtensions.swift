import ProjectDescription

extension Target {
    static func capabilitiesTarget(
        name: String,
        hasResources: Bool = false,
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
            destinations: [.iPhone, .iPad, .macCatalyst, .appleVisionWithiPadDesign],
            product: .framework,
            bundleId: "com.cocoatype.Highlighter.\(name)",
            buildableFolders: buildableFolders,
            dependencies: dependencies,
            settings: .settings(
                base: [
                    "DERIVE_MACCATALYST_PRODUCT_BUNDLE_IDENTIFIER": false,
                    "SWIFT_APPROACHABLE_CONCURRENCY": true,
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
        dependencies: [TargetDependency] = []
    ) -> Target {
        moduleTestTarget(
            name: name,
            type: "Capabilities",
            hasResources: hasResources,
            dependencies: dependencies
        )
    }

    static func moduleTestTarget(
        name: String,
        type: String,
        hasResources: Bool = false,
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
            destinations: [.iPhone, .iPad, .macCatalyst, .appleVisionWithiPadDesign],
            product: .unitTests,
            bundleId: "com.cocoatype.Highlighter.\(name)Tests",
            buildableFolders: buildableFolders,
            dependencies: [.target(name: name)] + dependencies,
            settings: .settings(
                base: [
                    "SWIFT_APPROACHABLE_CONCURRENCY": true,
                ],
                defaultSettings: .recommended(excluding: [
                    "CODE_SIGN_IDENTITY",
                ])
            )
        )
    }

    static func capabilitiesDoublesTarget(
        name: String,
        dependencies: [TargetDependency] = [],
    ) -> Target {
        return Target.target(
            name: "\(name)Doubles",
            destinations: [.iPhone, .iPad, .macCatalyst, .appleVisionWithiPadDesign],
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
                ],
                defaultSettings: .recommended(excluding: [
                    "CODE_SIGN_IDENTITY",
                ])
            )
        )
    }
}
