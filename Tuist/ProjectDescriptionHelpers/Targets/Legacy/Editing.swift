import ProjectDescription

public enum Editing {
    public static let target = Target.target(
        name: "Editing",
        destinations: [.iPhone, .iPad, .macCatalyst, .appleVisionWithiPadDesign],
        product: .framework,
        bundleId: "com.cocoatype.Highlighter.Editing",
        sources: ["Modules/Legacy/Editing/Sources/**"],
        resources: ["Modules/Legacy/Editing/Resources/**"],
        dependencies: [
            .target(AppRatings.target),
            .target(Brushes.target),
            .target(DebugOverlay.target),
            .target(Defaults.target),
            .target(DesignSystem.target),
            .target(Detections.target),
            .target(EditingToolbar.target),
            .target(ErrorHandling.target),
            .target(Exporting.target),
            .target(FeatureFlagging.target),
            .target(Geometry.target),
            .target(MobileAutoRedactionsUI.target),
            .target(Logging.target),
            .target(Observations.target),
            .target(Paywall.target),
            .target(Purchasing.target),
            .target(Redactions.target),
            .target(Tools.target),
            .target(Unpurchased.target),
            .target(UserActivities.target),
            .external(name: "ClippingBezier"),
            .external(name: "FactoryKit"),
        ],
        settings: .settings(
            base: [
                "ASSETCATALOG_COMPILER_GLOBAL_ACCENT_COLOR_NAME": "",
                "DERIVE_MACCATALYST_PRODUCT_BUNDLE_IDENTIFIER": false,
                // ClippingBezier ships private headers in its public headers folder; remove when ClippingBezier is
                "OTHER_SWIFT_FLAGS": ["$(inherited)", "-Xcc", "-Wno-incomplete-umbrella"],
                "SWIFT_APPROACHABLE_CONCURRENCY": true,
            ],
            defaultSettings: .recommended(excluding: [
                "CODE_SIGN_IDENTITY",
                "DERIVE_MACCATALYST_PRODUCT_BUNDLE_IDENTIFIER",
            ])
        )
    )

    public static let testTarget = Target.moduleTestTarget(
        name: "Editing",
        type: "Legacy",
        dependencies: [
            .target(Defaults.doublesTarget),
            .target(Geometry.target),
            .target(Logging.doublesTarget),
            .target(Logging.target),
            .target(MobileAutoRedactionsUI.target),
            .target(Observations.target),
            .target(Purchasing.doublesTarget),
            .target(Tools.target),
            .target(UserActivities.target),
            .external(name: "FactoryKit"),
            .external(name: "FactoryTesting"),
        ]
    )
}
