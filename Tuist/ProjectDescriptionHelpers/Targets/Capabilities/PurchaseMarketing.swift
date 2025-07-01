import ProjectDescription

public enum PurchaseMarketing {
    public static let target = Target.capabilitiesTarget(
        name: "PurchaseMarketing",
        hasResources: true,
        dependencies: [
            .target(DesignSystem.target),
            .target(ErrorHandling.target(sdk: .catalyst)),
            .target(Logging.target(sdk: .catalyst)),
            .target(Purchasing.target),
            .target(Purchasing.doublesTarget),
            .target(TestHelpers.interfaceTarget),
        ]
    )

    public static let testTarget = Target.capabilitiesTestTarget(
        name: "PurchaseMarketing",
        dependencies: [
            .target(Purchasing.doublesTarget),
            .target(Logging.doublesTarget),
            .external(name: "ViewInspector"),
        ]
    )
}
