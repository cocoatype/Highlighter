import ProjectDescription

public enum Exporting {
    public static let target = Target.capabilitiesTarget(
        name: "Exporting",
        hasResources: true,
        usesMaxSwiftVersion: false,
        dependencies: [
            .target(Defaults.target),
            .target(DesignSystem.target),
            .target(ErrorHandling.target(sdk: .catalyst)),
            .target(Geometry.target(sdk: .catalyst)),
            .target(Logging.target(sdk: .catalyst)),
            .target(Redactions.target(sdk: .catalyst)),
            .target(Rendering.target(sdk: .catalyst)),
            .external(name: "FactoryKit"),
        ]
    )

    public static let testTarget = Target.capabilitiesTestTarget(
        name: "Exporting",
        dependencies: [
            .target(Defaults.target),
            .target(Defaults.doublesTarget),
            .target(Logging.doublesTarget),
            .target(Logging.target(sdk: .catalyst)),
            .external(name: "FactoryKit"),
            .external(name: "FactoryTesting"),
        ]
    )
}
