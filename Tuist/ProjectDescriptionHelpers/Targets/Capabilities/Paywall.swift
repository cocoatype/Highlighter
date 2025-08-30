import ProjectDescription

public enum Paywall {
    public static let target = Target.capabilitiesTarget(
        name: "Paywall",
        hasResources: true,
        usesMaxSwiftVersion: true,
        dependencies: [
            .target(DesignSystem.target),
            .target(ErrorHandling.target),
            .target(Logging.target),
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
