import ProjectDescription

public enum Shortcuts {
    public static let target = Target.capabilitiesTarget(
        name: "Shortcuts",
        hasResources: true,
        dependencies: [
            .target(AppNavigation.target),
            .target(Defaults.target),
            .target(DesignSystem.target),
            .target(Detections.target(sdk: .catalyst)),
            .target(Logging.target(sdk: .catalyst)),
            .target(Observations.target(sdk: .catalyst)),
            .target(Purchasing.target),
            .target(Redactions.target(sdk: .catalyst)),
            .target(Rendering.target(sdk: .catalyst)),
            .target(UserActivities.target),
            .external(name: "FactoryKit"),
        ]
    )

    public static let testTarget = Target.capabilitiesTestTarget(
        name: "Shortcuts",
        dependencies: [
            .target(AppNavigation.doublesTarget),
            .target(Defaults.doublesTarget),
            .target(Detections.target(sdk: .catalyst)),
            .target(Logging.target(sdk: .catalyst)),
            .target(Logging.doublesTarget),
            .target(Observations.target(sdk: .catalyst)),
            .target(Purchasing.doublesTarget),
            .target(Redactions.target(sdk: .catalyst)),
            .target(Rendering.doublesTarget(sdk: .catalyst)),
            .external(name: "FactoryKit"),
            .external(name: "FactoryTesting"),
        ]
    )
}
