import ProjectDescription

public enum Widgets {
    public static let target = Target.target(
        name: "Widgets",
        destinations: [.iPhone],
        product: .appExtension,
        bundleId: "com.cocoatype.Highlighter.Widgets",
        infoPlist: "Widgets/Info.plist",
        sources: [
            "Widgets/Sources/**",
        ],
        resources: .resources([
            "Widgets/Resources/**",
        ]),
        entitlements: "Widgets/Widgets.entitlements",
        dependencies: [
            .target(Logging.target),
            .target(Shortcuts.target),
        ],
        settings: .settings(
            base: [
                "DERIVE_MACCATALYST_PRODUCT_BUNDLE_IDENTIFIER": "NO",
                "SWIFT_VERSION": "$(SWIFT_MAX_VERSION)",
            ],
            debug: [
                "PROVISIONING_PROFILE_SPECIFIER": "match Development com.cocoatype.Highlighter.Widgets",
                "ENABLE_DEBUG_DYLIB": true,
            ], release: [
                "PROVISIONING_PROFILE_SPECIFIER": "match AppStore com.cocoatype.Highlighter.Widgets",
            ],
            defaultSettings: .recommended(excluding: [
                "CODE_SIGN_IDENTITY",
            ])
        )
    )
}
