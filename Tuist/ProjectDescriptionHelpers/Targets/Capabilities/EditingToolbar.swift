import ProjectDescription

public enum EditingToolbar {
    public static let target = Target.capabilitiesTarget(
        name: "EditingToolbar",
        hasResources: true,
        usesMaxSwiftVersion: true,
        dependencies: [
            .target(FeatureFlags.target),
        ]
    )

    public static let testTarget = Target.capabilitiesTestTarget(
        name: "EditingToolbar",
        dependencies: [
        ]
    )
}
