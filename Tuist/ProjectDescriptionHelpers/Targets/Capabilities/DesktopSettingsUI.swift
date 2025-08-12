import ProjectDescription

public enum DesktopSettingsUI {
    public static let target = Target.capabilitiesTarget(
        name: "DesktopSettingsUI",
        hasResources: true,
        dependencies: [
        ]
    )

    public static let testTarget = Target.capabilitiesTestTarget(
        name: "DesktopSettingsUI",
        dependencies: [
        ]
    )
}
