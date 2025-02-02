import ProjectDescription

public enum Brushes {
    public static func target(sdk: SDK) -> Target {
        Target.capabilitiesTarget(
            name: "Brushes",
            sdk: sdk,
            hasResources: true,
            usesMaxSwiftVersion: true,
            dependencies: [
                .target(ErrorHandling.target(sdk: sdk)),
                .target(Geometry.target(sdk: sdk)),
            ]
        )
    }

    public static let testTarget = Target.capabilitiesTestTarget(
        name: "Brushes",
        dependencies: [
        ]
    )
}
