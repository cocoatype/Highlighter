import ProjectDescription

public enum Purchasing {
    public static let target = Target.capabilitiesTarget(
        name: "Purchasing",
        usesMaxSwiftVersion: false,
        dependencies: [
            .target(ErrorHandling.target(sdk: .catalyst)),
            .external(name: "FactoryKit"),
        ]
    )

    public static let testTarget = Target.capabilitiesTestTarget(
        name: "Purchasing",
        dependencies: [
            .target(doublesTarget),
        ]
    )

    public static let doublesTarget = Target.capabilitiesDoublesTarget(name: "Purchasing")
}
