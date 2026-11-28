import ProjectDescription

/// The main menu for the native AppKit app (#487). Its sources only compile
/// for native macOS; on other destinations the module is empty.
public enum MainMenu {
    public static let target = Target.capabilitiesTarget(
        name: "MainMenu",
        hasResources: true,
        supportsNativeMac: true,
        dependencies: [
        ]
    )

    public static let testTarget = Target.capabilitiesTestTarget(
        name: "MainMenu",
        supportsNativeMac: true,
        dependencies: [
        ]
    )
}
