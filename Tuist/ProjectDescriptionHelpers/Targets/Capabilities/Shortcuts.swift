import ProjectDescription

public enum Shortcuts {
    public static let target = Target.capabilitiesTarget(
        name: "Shortcuts",
        hasResources: true,
        usesMaxSwiftVersion: false,
        dependencies: [
            .target(AppNavigation.target),
            .target(Defaults.target),
            .target(DesignSystem.target),
            .target(Detections.target),
            .target(Logging.target),
            .target(Observations.target),
            .target(Purchasing.target),
            .target(Redactions.target),
            .target(Rendering.target),
            .target(UserActivities.target),
            .external(name: "FactoryKit"),
        ]
    )

    public static let testTarget = Target.capabilitiesTestTarget(
        name: "Shortcuts",
        usesMaxSwiftVersion: false,
        dependencies: [
            .target(AppNavigation.doublesTarget),
            .target(Defaults.doublesTarget),
            .target(Detections.target),
            .target(Logging.target),
            .target(Logging.doublesTarget),
            .target(Observations.target),
            .target(Purchasing.doublesTarget),
            .target(Redactions.target),
            .target(Rendering.doublesTarget),
            .external(name: "FactoryKit"),
            .external(name: "FactoryTesting"),
        ]
    )
}
