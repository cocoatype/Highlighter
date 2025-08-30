import ProjectDescription

public enum Brushes {
    public static let target = Target.capabilitiesTarget(
        name: "Brushes",
        hasResources: true,
        usesMaxSwiftVersion: true,
        dependencies: [
            .target(ErrorHandling.target),
            .target(Geometry.target),
            .external(name: "FactoryKit"),
        ]
    )

    public static let testTarget = Target.capabilitiesTestTarget(
        name: "Brushes",
        dependencies: [
            .target(Geometry.target),
        ]
    )
}
