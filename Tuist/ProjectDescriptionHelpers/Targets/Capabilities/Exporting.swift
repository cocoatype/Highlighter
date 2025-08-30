import ProjectDescription

public enum Exporting {
    public static let target = Target.capabilitiesTarget(
        name: "Exporting",
        hasResources: true,
        usesMaxSwiftVersion: false,
        dependencies: [
            .target(Defaults.target),
            .target(DesignSystem.target),
            .target(ErrorHandling.target),
            .target(Geometry.target),
            .target(Logging.target),
            .target(Redactions.target),
            .target(Rendering.target),
            .external(name: "FactoryKit"),
        ]
    )

    public static let testTarget = Target.capabilitiesTestTarget(
        name: "Exporting",
        dependencies: [
            .target(Defaults.target),
            .target(Defaults.doublesTarget),
            .target(Logging.doublesTarget),
            .target(Logging.target),
            .external(name: "FactoryKit"),
            .external(name: "FactoryTesting"),
        ]
    )
}
