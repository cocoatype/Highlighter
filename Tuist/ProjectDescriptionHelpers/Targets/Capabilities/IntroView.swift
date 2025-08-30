import ProjectDescription

public enum IntroView {
    public static let target = Target.capabilitiesTarget(
        name: "IntroView",
        hasResources: true,
        usesMaxSwiftVersion: true,
        dependencies: [
            .target(AppNavigation.target),
            .target(DesignSystem.target),
            .target(Logging.target),
            .target(MobileSettingsUI.target),
            .target(PhotoPermissions.target),
            .target(PhotoPicker.target),
            .external(name: "FactoryKit"),
        ]
    )

    public static let testTarget = Target.capabilitiesTestTarget(
        name: "IntroView",
        dependencies: [
            .external(name: "ViewInspector"),
        ]
    )
}
