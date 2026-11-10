import ProjectDescription

public enum DesktopSettingsUI {
    public static let target = Target.capabilitiesTarget(
        name: "DesktopSettingsUI",
        dependencies: [
            .target(DesignSystem.target),
            .target(DesktopAutoRedactionsUI.target),
            .target(Paywall.target),
            .target(Purchasing.target),
            .external(name: "FactoryKit"),
        ]
    )

    public static let testTarget = Target.capabilitiesTestTarget(
        name: "DesktopSettingsUI",
        dependencies: [
            .target(Purchasing.doublesTarget),
            .target(Purchasing.target),
            .external(name: "FactoryKit"),
            .external(name: "FactoryTesting"),
        ]
    )
}
