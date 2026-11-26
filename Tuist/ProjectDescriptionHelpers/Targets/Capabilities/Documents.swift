import ProjectDescription

/// The document model for the native AppKit app (#497). Its sources only
/// compile for native macOS; on other destinations the module is empty.
public enum Documents {
    public static let target = Target.capabilitiesTarget(
        name: "Documents",
        supportsNativeMac: true,
        dependencies: [
        ]
    )

    public static let testTarget = Target.capabilitiesTestTarget(
        name: "Documents",
        supportsNativeMac: true,
        dependencies: [
        ]
    )
}
