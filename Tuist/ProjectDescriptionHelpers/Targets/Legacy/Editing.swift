import ProjectDescription

public enum Editing {
    public static let target = Target.target(
        name: "Editing",
        destinations: SDK.catalyst.destinations,
        product: .framework,
        bundleId: "com.cocoatype.Highlighter.Editing",
        sources: ["Modules/Legacy/Editing/Sources/**"],
        resources: ["Modules/Legacy/Editing/Resources/**"],
        dependencies: [
            .target(AutoRedactionsUI.target),
            .target(Brushes.target(sdk: .catalyst)),
            .target(DebugOverlay.target),
            .target(Detections.target(sdk: .catalyst)),
            .target(EditingToolbar.target),
            .target(ErrorHandling.target(sdk: .catalyst)),
            .target(Exporting.target),
            .target(Observations.target(sdk: .catalyst)),
            .target(PurchaseMarketing.target),
            .target(Purchasing.doublesTarget),
            .target(Redactions.target(sdk: .catalyst)),
            .target(Rendering.target(sdk: .catalyst)),
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
            ],
            defaultSettings: .recommended(excluding: [
                "CODE_SIGN_IDENTITY",
                "DERIVE_MACCATALYST_PRODUCT_BUNDLE_IDENTIFIER",
            ])
        )
    )

    public static let testTarget = Target.moduleTestTarget(
        name: "Editing",
        sdk: .catalyst,
        type: "Legacy",
        dependencies: [
            .target(AutoRedactionsUI.target),
            .target(Defaults.doublesTarget),
            .target(Geometry.target(sdk: .catalyst)),
            .target(Logging.doublesTarget),
            .target(Logging.target(sdk: .catalyst)),
            .target(Purchasing.doublesTarget),
            .target(Tools.target),
        ]
    )
}
