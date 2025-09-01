import ProjectDescription

public enum DocumentScanning {
    public static let target = Target.capabilitiesTarget(
        name: "DocumentScanning",
        hasResources: true,
        usesMaxSwiftVersion: true,
        dependencies: [
            .target(AppNavigation.target),
            .target(BarBuilder.target),
            .target(DesignSystem.target),
            .target(Editing.target),
            .target(Logging.target),
            .target(Purchasing.target),
            .target(Unpurchased.target),
            .external(name: "FactoryKit"),
        ]
    )

    public static let testTarget = Target.capabilitiesTestTarget(
        name: "DocumentScanning",
        dependencies: [
            .target(Purchasing.doublesTarget),
            .target(Purchasing.target),
            .external(name: "FactoryKit"),
            .external(name: "FactoryTesting"),
        ]
    )
}
