import ProjectDescription

public enum PhotoLibrary {
    public static let target = Target.capabilitiesTarget(
        name: "PhotoLibrary",
        hasResources: true,
        usesMaxSwiftVersion: false,
        dependencies: [
            .target(AlbumsData.target),
            .target(AlbumsUI.target),
            .target(AppNavigation.target),
            .target(Defaults.target),
            .target(DesignSystem.target),
            .target(DocumentScanning.target),
            .target(Editing.target),
            .target(ErrorHandling.target),
            .target(Geometry.target),
            .target(Logging.target),
            .target(MobileSettingsUI.target),
            .target(PhotoAssets.target),
            .target(PhotoPermissions.target),
            .target(Purchasing.target),
            .target(UserActivities.target),
            .external(name: "FactoryKit"),
        ]
    )

    public static let testTarget = Target.capabilitiesTestTarget(
        name: "PhotoLibrary",
        dependencies: [
            .target(Defaults.doublesTarget),
            .external(name: "FactoryKit"),
            .external(name: "FactoryTesting"),
        ]
    )
}
