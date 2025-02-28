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
        // modules
        AlbumsData.target,
        AlbumsUI.target,
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
        Editing.target,
        EditingToolbar.target,
        ErrorHandling.target(sdk: .catalyst),
        ErrorHandling.target(sdk: .native),
        Exporting.target,
        FeatureFlagging.target,
        Geometry.target(sdk: .catalyst),
        Geometry.target(sdk: .native),
        Logging.target(sdk: .catalyst),
        Logging.target(sdk: .native),
        Observations.target(sdk: .catalyst),
        Observations.target(sdk: .native),
        PurchaseMarketing.target,
        Purchasing.target,
        Redacting.target,
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
        DesignSystem.doublesTarget,
        Logging.doublesTarget,
        Purchasing.doublesTarget,
        // test helpers
        TestHelpers.target,
        TestHelpers.interfaceTarget,
        // tests
        AlbumsData.testTarget,
        AlbumsUI.testTarget,
        AppRatings.testTarget,
        AutoRedactionsUI.testTarget,
        Brushes.testTarget,
        Core.testTarget,
        Detections.testTarget,
        Editing.testTarget,
        EditingToolbar.testTarget,
        ErrorHandling.testTarget,
        Exporting.testTarget,
        FeatureFlagging.testTarget,
        Geometry.testTarget,
        Logging.testTarget,
        Observations.testTarget,
        PurchaseMarketing.testTarget,
        Purchasing.testTarget,
        Redactions.testTarget,
        Rendering.testTarget,
        Scenes.testTarget,
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
