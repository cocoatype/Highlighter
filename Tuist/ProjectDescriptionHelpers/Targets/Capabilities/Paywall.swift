import ProjectDescription

public enum Paywall {
    public static let target = Target.capabilitiesTarget(
        name: "Paywall",
        hasResources: true,
        dependencies: [
            .target(DesignSystem.target),
            .target(ErrorHandling.target(sdk: .catalyst)),
            .target(Logging.target(sdk: .catalyst)),
            .target(Purchasing.doublesTarget),
            .target(Purchasing.target),
            .target(TestHelpers.interfaceTarget),
            .external(name: "FactoryKit"),
        ]
    )

    public static let testTarget = Target.capabilitiesTestTarget(
        name: "Paywall",
        dependencies: [
            .target(Purchasing.doublesTarget),
            .target(Logging.doublesTarget),
            .external(name: "FactoryKit"),
            .external(name: "FactoryTesting"),
            .external(name: "ViewInspector"),
        ]
    )
}
