import ProjectDescription

public enum Purchasing {
    public static let target = Target.capabilitiesTarget(
        name: "Purchasing",
        supportsNativeMac: true,
        dependencies: [
            .target(Defaults.target),
            .target(ErrorHandling.target),
            .external(name: "FactoryKit"),
        ]
    )

    public static let testTarget = Target.capabilitiesTestTarget(
        name: "Purchasing",
        supportsNativeMac: true,
        dependencies: [
            .target(doublesTarget),
            .target(Defaults.target),
            .target(Defaults.doublesTarget),
            .target(ErrorHandling.target),
            .external(name: "FactoryKit"),
            .external(name: "FactoryTesting"),
        ]
    )

    public static let doublesTarget = Target.capabilitiesDoublesTarget(
        name: "Purchasing",
        supportsNativeMac: true,
        dependencies: [
            .target(TestHelpers.interfaceTarget),
        ],
    )
}
