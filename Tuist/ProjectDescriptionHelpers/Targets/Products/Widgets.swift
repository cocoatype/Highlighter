import ProjectDescription

public enum Widgets {
    public static let target = Target.target(
        name: "Widgets",
        destinations: [.iPhone],
        product: .appExtension,
        bundleId: "com.cocoatype.Highlighter.Widgets",
        infoPlist: "Widgets/Info.plist",
        buildableFolders: [
            .folder("Widgets/Sources"),
            .folder("Widgets/Resources"),
        ],
        entitlements: "Widgets/Widgets.entitlements",
        dependencies: [
            .target(Logging.target),
            .target(Shortcuts.target),
        ],
        settings: .settings(
            base: [
                "DERIVE_MACCATALYST_PRODUCT_BUNDLE_IDENTIFIER": "NO",
                "SWIFT_APPROACHABLE_CONCURRENCY": true,
                "SWIFT_UPCOMING_FEATURE_EXISTENTIAL_ANY": true,
            ],
            debug: [
                "ENABLE_DEBUG_DYLIB": true,
            ], release: [
                "PROVISIONING_PROFILE_SPECIFIER": "Black Highlighter (iOS Widgets Extension)",
            ],
            defaultSettings: .recommended(excluding: [
                "CODE_SIGN_IDENTITY",
            ])
        )
    )
}
