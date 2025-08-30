import ProjectDescription

public enum AppRatings {
    public static let target = Target.capabilitiesTarget(
        name: "AppRatings",
        usesMaxSwiftVersion: true,
        dependencies: [
            .target(Defaults.target),
            .target(ErrorHandling.target),
            .target(Logging.target),
            .target(Paywall.target),
            .target(Purchasing.target),
            .external(name: "FactoryKit"),
        ]
    )

    public static let testTarget = Target.capabilitiesTestTarget(
        name: "AppRatings",
        dependencies: [
            .target(Defaults.target),
            .target(Defaults.doublesTarget),
            .target(Editing.target),
            .target(Logging.doublesTarget),
            .target(Logging.target),
            .target(TestHelpers.target),
            .external(name: "FactoryKit"),
            .external(name: "FactoryTesting"),
        ]
    )
}
