import ProjectDescription

public enum Defaults {
    public static let target = Target.capabilitiesTarget(
        name: "Defaults",
        supportsNativeMac: true,
        dependencies: [
            .external(name: "FactoryKit"),
        ],
    )

    public static let testTarget = Target.capabilitiesTestTarget(
        name: "Defaults",
        supportsNativeMac: true,
        dependencies: [
            .target(TestHelpers.target),
        ]
    )

    public static let doublesTarget = Target.capabilitiesDoublesTarget(
        name: "Defaults",
        supportsNativeMac: true,
    )
}
