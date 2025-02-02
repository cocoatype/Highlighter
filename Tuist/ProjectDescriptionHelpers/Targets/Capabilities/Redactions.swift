import ProjectDescription

public enum Redactions {
    public static func target(sdk: SDK) -> Target {
        Target.capabilitiesTarget(
            name: "Redactions",
            sdk: sdk,
            usesMaxSwiftVersion: true,
            dependencies: [
                .target(Geometry.target(sdk: sdk)),
                .target(Observations.target(sdk: sdk)),
            ]
        )
    }

    public static let testTarget = Target.capabilitiesTestTarget(
        name: "Redactions",
        dependencies: [
            .target(Observations.target(sdk: .catalyst)),
            .target(TestHelpers.target),
        ]
    )
}
