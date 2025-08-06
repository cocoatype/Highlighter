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
        AutomatorActions.target,
        Photo.target,
        Widgets.target,
        // modules
        AlbumsData.target,
        AppNavigation.target,
        AppRatings.target,
        AutoRedactionsUI.target,
        Brushes.target(sdk: .catalyst),
        Brushes.target(sdk: .native),
        Core.target,
        DebugOverlay.target,
        Defaults.target,
        DesignSystem.target,
        Detections.target(sdk: .catalyst),
        Detections.target(sdk: .native),
        DocumentScanning.target,
        Editing.target,
        EditingToolbar.target,
        ErrorHandling.target(sdk: .catalyst),
        ErrorHandling.target(sdk: .native),
        Exporting.target,
        FeatureFlagging.target,
        Geometry.target(sdk: .catalyst),
        Geometry.target(sdk: .native),
        ImageOpening.target,
        IntroView.target,
        LegacyAlbumsUI.target,
        LegacyPhotoLibrary.target,
        Logging.target(sdk: .catalyst),
        Logging.target(sdk: .native),
        Observations.target(sdk: .catalyst),
        Observations.target(sdk: .native),
        Paywall.target,
        PhotoPermissions.target,
        PhotoPicker.target,
        Purchasing.target,
        Redactions.target(sdk: .catalyst),
        Redactions.target(sdk: .native),
        Rendering.target(sdk: .catalyst),
        Rendering.target(sdk: .native),
        Scenes.target,
        SettingsUI.target,
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
        Rendering.doublesTarget(sdk: .catalyst),
        // test helpers
        TestHelpers.target,
        TestHelpers.interfaceTarget,
        // tests
        AppRatings.testTarget,
        AutoRedactionsUI.testTarget,
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
        LegacyPhotoLibrary.testTarget,
        Logging.testTarget,
        Observations.testTarget,
        Paywall.testTarget,
        PhotoPermissions.testTarget,
        PhotoPicker.testTarget,
        Purchasing.testTarget,
        Redactions.testTarget,
        SettingsUI.testTarget,
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
