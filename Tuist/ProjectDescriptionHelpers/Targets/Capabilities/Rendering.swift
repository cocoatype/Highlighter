import ProjectDescription

public enum Rendering {
    public static func target(sdk: SDK) -> Target {
        Target.capabilitiesTarget(
            name: "Rendering",
            sdk: sdk,
            dependencies: [
                .target(Brushes.target(sdk: sdk)),
                .target(Geometry.target(sdk: sdk)),
                .target(Observations.target(sdk: sdk)),
                .target(Redactions.target(sdk: sdk)),
            ]
        )
    }

    public static let testTarget = Target.capabilitiesTestTarget(
        name: "Rendering",
        dependencies: [
        ]
    )
}
