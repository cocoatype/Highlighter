import ProjectDescription

public enum EditingToolbar {
    public static let target = Target.capabilitiesTarget(
        name: "EditingToolbar",
        hasResources: true,
        usesMaxSwiftVersion: true,
        dependencies: [
            .target(BarBuilder.target),
            .target(Defaults.target),
            .target(DesignSystem.target),
            .target(FeatureFlagging.target),
            .target(Purchasing.target),
            .target(Tools.target),
            .external(name: "FactoryKit"),
        ]
    )

    public static let testTarget = Target.capabilitiesTestTarget(
        name: "EditingToolbar",
        usesMaxSwiftVersion: true,
        dependencies: [
            .target(Defaults.target),
            .target(Defaults.doublesTarget),
            .target(Purchasing.doublesTarget),
            .target(Purchasing.target),
            .target(Tools.target),
            .external(name: "FactoryKit"),
            .external(name: "FactoryTesting"),
        ]
    )
}
