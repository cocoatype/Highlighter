import ProjectDescription
import ProjectDescriptionHelpers

let project = Project(
    name: "Highlighter",
    organizationName: "Cocoatype, LLC",
    settings: Shared.settings,
    targets: [
        // products
        App.target,
        Action.target,
        Photo.target,
        Widgets.target,
        // modules
        AlbumsData.target,
        AlbumsUI.target,
        AppNavigation.target,
        AppRatings.target,
        BarBuilder.target,
        Brushes.target,
        Core.target,
        DebugOverlay.target,
        Defaults.target,
        DesignSystem.target,
        DesktopAutoRedactionsUI.target,
        DesktopSettingsUI.target,
        Detections.target,
        DocumentScanning.target,
        Editing.target,
        EditingToolbar.target,
        ErrorHandling.target,
        Exporting.target,
        FeatureFlagging.target,
        Geometry.target,
        ImageOpening.target,
        IntroView.target,
        Logging.target,
        MobileAutoRedactionsUI.target,
        MobileSettingsUI.target,
        Observations.target,
        Paywall.target,
        PhotoAssets.target,
        PhotoLibrary.target,
        PhotoPermissions.target,
        PhotoPicker.target,
        Purchasing.target,
        Redactions.target,
        Rendering.target,
        Scenes.target,
        Shortcuts.target,
        Tools.target,
        Unpurchased.target,
        URLParsing.target,
        UserActivities.target,
        // doubles
        AppNavigation.doublesTarget,
        Defaults.doublesTarget,
        DesignSystem.doublesTarget,
        Logging.doublesTarget,
        Purchasing.doublesTarget,
        Rendering.doublesTarget,
        // test helpers
        TestHelpers.target,
        TestHelpers.interfaceTarget,
        // tests
        AppRatings.testTarget,
        Brushes.testTarget,
        Core.testTarget,
        Defaults.testTarget,
        DocumentScanning.testTarget,
        Editing.testTarget,
        EditingToolbar.testTarget,
        ErrorHandling.testTarget,
        Exporting.testTarget,
        FeatureFlagging.testTarget,
        Geometry.testTarget,
        ImageOpening.testTarget,
        IntroView.testTarget,
        Logging.testTarget,
        MobileAutoRedactionsUI.testTarget,
        MobileSettingsUI.testTarget,
        Observations.testTarget,
        Paywall.testTarget,
        PhotoAssets.testTarget,
        PhotoLibrary.testTarget,
        PhotoPermissions.testTarget,
        PhotoPicker.testTarget,
        Purchasing.testTarget,
        Redactions.testTarget,
        Shortcuts.testTarget,
        Tools.testTarget,
        Unpurchased.testTarget,
        URLParsing.testTarget,
        UserActivities.testTarget,
    ],
    schemes: [
        .scheme(
            name: "Highlighter",
            buildAction: .buildAction(targets: [
                .target(App.target.name),
            ]),
            testAction: .testPlans([
                "Highlighter.xctestplan",
            ]),
            runAction: .runAction(
                arguments: .arguments(
                    environmentVariables: [
                        "OVERRIDE_PURCHASE": .environmentVariable(value: "", isEnabled: false),
                        "SHOW_DEBUG_OVERLAY": .environmentVariable(value: "", isEnabled: false),
                    ],
                    launchArguments: [
                    ]
                ),
                options: .options(
                    storeKitConfigurationPath: "App/Configuration.storekit"
                )
            )
        ),
    ]
)
