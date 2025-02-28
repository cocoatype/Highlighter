import ProjectDescription

public enum FeatureFlagging {
    public static let target = Target.capabilitiesTarget(
        name: "FeatureFlagging",
        usesMaxSwiftVersion: true,
        dependencies: [
        ]
    )

    public static let testTarget = Target.capabilitiesTestTarget(
        name: "FeatureFlagging",
        dependencies: [
        ]
    )
}
