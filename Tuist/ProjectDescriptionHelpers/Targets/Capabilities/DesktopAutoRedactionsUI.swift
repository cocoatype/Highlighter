import ProjectDescription

public enum DesktopAutoRedactionsUI {
    public static let target = Target.capabilitiesTarget(
        name: "DesktopAutoRedactionsUI",
        hasResources: true,
        dependencies: [
            .target(DesignSystem.target),
        ]
    )

    public static let testTarget = Target.capabilitiesTestTarget(
        name: "DesktopAutoRedactionsUI",
        dependencies: [
        ]
    )
}
