import ProjectDescription

public enum Defaults {
    public static let target = Target.capabilitiesTarget(
        name: "Defaults",
        usesMaxSwiftVersion: true
    )

    public static let testTarget = Target.capabilitiesTestTarget(
        name: "Defaults",
        dependencies: [
        ]
    )

    public static let doublesTarget = Target.capabilitiesDoublesTarget(
        name: "Defaults"
    )
}
