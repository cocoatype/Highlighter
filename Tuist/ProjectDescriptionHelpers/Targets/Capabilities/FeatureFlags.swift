import ProjectDescription

public enum FeatureFlags {
    public static let target = Target.capabilitiesTarget(
        name: "FeatureFlags",
        usesMaxSwiftVersion: true,
        dependencies: [
        ]
    )

    public static let testTarget = Target.capabilitiesTestTarget(
        name: "FeatureFlags",
        dependencies: [
        ]
    )
}
