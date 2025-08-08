import ProjectDescription

public enum Core {
    public static let target = Target.target(
        name: "Core",
        destinations: SDK.catalyst.destinations,
        product: .framework,
        bundleId: "com.cocoatype.Highlighter.Core",
        sources: ["Modules/Legacy/Core/Sources/**"],
        resources: ["Modules/Legacy/Core/Resources/**"],
        headers: .headers(public: ["Modules/Legacy/Core/Headers/**"]),
        dependencies: [
            .target(AlbumsData.target),
            .target(AlbumsUI.target),
            .target(AppNavigation.target),
            .target(AppRatings.target),
            .target(Defaults.target),
            .target(DesignSystem.target),
            .target(Detections.target(sdk: .catalyst)),
            .target(DocumentScanning.target),
            .target(Editing.target),
            .target(EditingToolbar.target),
            .target(ErrorHandling.target(sdk: .catalyst)),
            .target(Exporting.target),
            .target(Geometry.target(sdk: .catalyst)),
            .target(ImageOpening.target),
            .target(IntroView.target),
            .target(Logging.target(sdk: .catalyst)),
            .target(Paywall.target),
            .target(PhotoLibrary.target),
            .target(PhotoPermissions.target),
            .target(Purchasing.target),
            .target(Redactions.target(sdk: .catalyst)),
            .target(Scenes.target),
            .target(SettingsUI.target),
            .target(Tools.target),
            .target(Unpurchased.target),
            .target(URLParsing.target),
            .target(UserActivities.target),
            .external(name: "FactoryKit"),
        ],
        settings: .settings(
            base: [
                "DERIVE_MACCATALYST_PRODUCT_BUNDLE_IDENTIFIER": false,
                "OTHER_SWIFT_FLAGS": [
                    "-enable-upcoming-feature",
                    "IsolatedDefaultValues",
                ],
                "SWIFT_VERSION": "$(SWIFT_MAX_VERSION)",
            ],
            defaultSettings: .recommended(excluding: [
                "CODE_SIGN_IDENTITY",
                "DERIVE_MACCATALYST_PRODUCT_BUNDLE_IDENTIFIER",
            ])
        )
    )

    public static let testTarget = Target.moduleTestTarget(
        name: "Core",
        sdk: .catalyst,
        type: "Legacy",
        dependencies: [
            .target(Defaults.target),
            .target(Defaults.doublesTarget),
            .target(DesignSystem.doublesTarget),
            .target(Logging.doublesTarget),
            .target(Purchasing.doublesTarget),
            .target(TestHelpers.target),
            .external(name: "FactoryKit"),
            .external(name: "FactoryTesting"),
        ]
    )
}
