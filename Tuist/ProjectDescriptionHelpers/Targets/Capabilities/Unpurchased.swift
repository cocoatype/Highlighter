import ProjectDescription

public enum Unpurchased {
    public static let target = Target.capabilitiesTarget(
        name: "Unpurchased",
        hasResources: true,
        usesMaxSwiftVersion: true,
        dependencies: [
            .target(Defaults.target),
            .target(DesignSystem.target),
            .target(Logging.target),
            .external(name: "FactoryKit"),
        ]
    )

    public static let testTarget = Target.capabilitiesTestTarget(
        name: "Unpurchased",
        usesMaxSwiftVersion: true,
        dependencies: [
            .target(Defaults.target),
            .target(Defaults.doublesTarget),
            .target(DesignSystem.target),
            .target(Logging.doublesTarget),
            .external(name: "FactoryKit"),
            .external(name: "FactoryTesting"),
            .external(name: "ViewInspector"),
        ]
    )
}
