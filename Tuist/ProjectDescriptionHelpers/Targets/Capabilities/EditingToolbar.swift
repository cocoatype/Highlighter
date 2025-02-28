import ProjectDescription

public enum EditingToolbar {
    public static let target = Target.capabilitiesTarget(
        name: "EditingToolbar",
        hasResources: true,
        usesMaxSwiftVersion: true,
        dependencies: [
            .target(Defaults.target),
            .target(DesignSystem.target),
            .target(FeatureFlagging.target),
            .target(Purchasing.target),
            .target(Tools.target),
        ]
    )

    public static let testTarget = Target.capabilitiesTestTarget(
        name: "EditingToolbar",
        dependencies: [
            .target(Defaults.target),
            .target(Purchasing.doublesTarget),
            .target(Purchasing.target),
            .target(Tools.target),
        ]
    )
}
