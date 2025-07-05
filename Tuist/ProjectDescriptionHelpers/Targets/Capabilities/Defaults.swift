import ProjectDescription

public enum Defaults {
    public static let target = Target.capabilitiesTarget(
        name: "Defaults",
        usesMaxSwiftVersion: true,
        dependencies: [
            .external(name: "FactoryKit"),
        ],
    )

    public static let testTarget = Target.capabilitiesTestTarget(
        name: "Defaults",
        dependencies: [
            .target(TestHelpers.target),
        ]
    )

    public static let doublesTarget = Target.capabilitiesDoublesTarget(
        name: "Defaults"
    )
}
