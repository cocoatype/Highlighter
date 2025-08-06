import ProjectDescription

public enum LegacyPhotoLibrary {
    public static let target = Target.capabilitiesTarget(
        name: "LegacyPhotoLibrary",
        hasResources: true,
        usesMaxSwiftVersion: false,
        dependencies: [
            .target(AlbumsData.target),
            .target(AppNavigation.target),
            .target(Defaults.target),
            .target(DesignSystem.target),
            .target(Editing.target),
            .target(ErrorHandling.target(sdk: .catalyst)),
            .target(Geometry.target(sdk: .catalyst)),
            .target(LegacyAlbumsUI.target),
            .target(Logging.target(sdk: .catalyst)),
            .target(PhotoPermissions.target),
            .target(Purchasing.target),
            .target(SettingsUI.target),
            .target(UserActivities.target),
            .external(name: "FactoryKit"),
        ]
    )

    public static let testTarget = Target.capabilitiesTestTarget(
        name: "LegacyPhotoLibrary",
        dependencies: [
            .target(Defaults.doublesTarget),
            .external(name: "FactoryKit"),
            .external(name: "FactoryTesting"),
        ]
    )
}
