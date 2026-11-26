import ProjectDescription

public enum Redactions {
    public static let target = Target.capabilitiesTarget(
        name: "Redactions",
        dependencies: [
            .target(ErrorHandling.target),
            .target(Geometry.target),
            .target(Observations.target),
            .external(name: "FactoryKit"),
        ]
    )

    public static let testTarget = Target.capabilitiesTestTarget(
        name: "Redactions",
        hasResources: true,
        dependencies: [
            .target(Geometry.target),
            .target(Observations.target),
            .target(TestHelpers.target),
        ]
    )
}
