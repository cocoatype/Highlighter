import ProjectDescription

public enum Redactions {
    public static func target(sdk: SDK) -> Target {
        Target.capabilitiesTarget(
            name: "Redactions",
            sdk: sdk,
            usesMaxSwiftVersion: true,
            dependencies: [
                .target(ErrorHandling.target(sdk: sdk)),
                .target(Geometry.target(sdk: sdk)),
                .target(Observations.target(sdk: sdk)),
            ]
        )
    }

    public static let testTarget = Target.capabilitiesTestTarget(
        name: "Redactions",
        dependencies: [
            .target(Geometry.target(sdk: .catalyst)),
            .target(Observations.target(sdk: .catalyst)),
            .target(TestHelpers.target),
        ]
    )
}
