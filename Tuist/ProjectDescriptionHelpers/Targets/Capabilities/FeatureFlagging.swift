import ProjectDescription

public enum FeatureFlagging {
    public static let target = Target.capabilitiesTarget(
        name: "FeatureFlagging",
        dependencies: [
            .external(name: "FactoryKit"),
        ]
    )

    public static let testTarget = Target.capabilitiesTestTarget(
        name: "FeatureFlagging",
        dependencies: [
        ]
    )
}
