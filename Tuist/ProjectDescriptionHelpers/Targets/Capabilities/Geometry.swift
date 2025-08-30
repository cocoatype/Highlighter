import ProjectDescription

public enum Geometry {
    public static let target = Target.capabilitiesTarget(
        name: "Geometry",
        usesMaxSwiftVersion: true,
        dependencies: [
        ]
    )

    public static let testTarget = Target.capabilitiesTestTarget(
        name: "Geometry",
        dependencies: [
        ]
    )
}
