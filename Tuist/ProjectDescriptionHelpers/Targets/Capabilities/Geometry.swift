import ProjectDescription

public enum Geometry {
    public static func target(sdk: SDK) -> Target {
        Target.capabilitiesTarget(
            name: "Geometry",
            sdk: sdk,
            usesMaxSwiftVersion: true,
            dependencies: [
            ]
        )
    }

    public static let testTarget = Target.capabilitiesTestTarget(
        name: "Geometry",
        dependencies: [
        ]
    )
}
