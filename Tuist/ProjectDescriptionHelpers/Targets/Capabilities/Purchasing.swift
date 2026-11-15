import ProjectDescription

public enum Purchasing {
    public static let target = Target.capabilitiesTarget(
        name: "Purchasing",
        dependencies: [
            .target(Defaults.target),
            .target(ErrorHandling.target),
            .external(name: "FactoryKit"),
        ]
    )

    public static let testTarget = Target.capabilitiesTestTarget(
        name: "Purchasing",
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
        dependencies: [
            .target(TestHelpers.interfaceTarget),
        ],
    )
}
