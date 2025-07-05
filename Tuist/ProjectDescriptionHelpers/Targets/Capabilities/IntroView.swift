import ProjectDescription

public enum IntroView {
    public static let target = Target.capabilitiesTarget(
        name: "IntroView",
        hasResources: true,
        usesMaxSwiftVersion: true,
        dependencies: [
            .target(AppNavigation.target),
            .target(DesignSystem.target),
            .target(Logging.target(sdk: .catalyst)),
            .target(PhotoPermissions.target),
            .target(PhotoPicker.target),
            .target(SettingsUI.target),
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
