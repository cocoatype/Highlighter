import ProjectDescription

public enum Redactions {
    public static let target = Target.capabilitiesTarget(
        name: "Redactions",
        usesMaxSwiftVersion: true,
        dependencies: [
            .target(ErrorHandling.target),
            .target(Geometry.target),
            .target(Observations.target),
        ]
    )

    public static let testTarget = Target.capabilitiesTestTarget(
        name: "Redactions",
        dependencies: [
            .target(Geometry.target),
            .target(Observations.target),
            .target(TestHelpers.target),
        ]
    )
}
