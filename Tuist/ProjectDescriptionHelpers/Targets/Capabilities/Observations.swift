import ProjectDescription

public enum Observations {
    public static let target = Target.capabilitiesTarget(
        name: "Observations",
        usesMaxSwiftVersion: true,
        dependencies: [
            .target(Geometry.target),
        ]
    )

    public static let testTarget = Target.capabilitiesTestTarget(
        name: "Observations",
        dependencies: [
            .target(Geometry.target),
        ]
    )
}
