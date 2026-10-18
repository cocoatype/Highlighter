import ProjectDescription

public enum MobileSettingsUI {
    public static let target = Target.capabilitiesTarget(
        name: "MobileSettingsUI",
        hasResources: true,
        usesMaxSwiftVersion: true,
        dependencies: [
            .target(Defaults.target),
            .target(DesignSystem.target),
            .target(ErrorHandling.target),
            .target(MobileAutoRedactionsUI.target),
            .target(Paywall.target),
            .target(Purchasing.doublesTarget),
            .target(Purchasing.target),
            .target(Unpurchased.target),
            .external(name: "FactoryKit"),
            .external(name: "SwiftUIIntrospect-Dynamic"),
        ]
    )

    public static let testTarget = Target.capabilitiesTestTarget(
        name: "MobileSettingsUI",
        dependencies: [
            .target(MobileAutoRedactionsUI.target),
            .target(Paywall.target),
            .target(Purchasing.target),
            .external(name: "ViewInspector"),
        ]
    )
}
