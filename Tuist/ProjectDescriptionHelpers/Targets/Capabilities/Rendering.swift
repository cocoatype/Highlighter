import ProjectDescription

public enum Rendering {
    public static let target = Target.capabilitiesTarget(
        name: "Rendering",
        usesMaxSwiftVersion: true,
        dependencies: [
            .target(Brushes.target),
            .target(Geometry.target),
            .target(Observations.target),
            .target(Redactions.target),
        ]
    )

    public static let testTarget = Target.capabilitiesTestTarget(
        name: "Rendering",
        usesMaxSwiftVersion: true,
        dependencies: [
        ]
    )

    public static let doublesTarget = Target.capabilitiesDoublesTarget(name: "Rendering")
}
