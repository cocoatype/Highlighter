import ProjectDescription

public enum LegacyAlbumsUI {
    public static let target = Target.capabilitiesTarget(
        name: "LegacyAlbumsUI",
        hasResources: true,
        usesMaxSwiftVersion: false,
        dependencies: [
            .target(AlbumsData.target),
            .target(AppNavigation.target),
            .target(DesignSystem.target),
            .target(Redactions.target(sdk: .catalyst)),
            .external(name: "SwiftUIIntrospect"),
        ]
    )

    public static let testTarget = Target.capabilitiesTestTarget(name: "LegacyAlbumsUI")
}
