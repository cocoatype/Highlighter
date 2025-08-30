import ProjectDescription

public enum AlbumsUI {
    public static let target = Target.capabilitiesTarget(
        name: "AlbumsUI",
        hasResources: true,
        usesMaxSwiftVersion: false,
        dependencies: [
            .target(AlbumsData.target),
            .target(AppNavigation.target),
            .target(DesignSystem.target),
            .target(Redactions.target),
            .external(name: "SwiftUIIntrospect"),
        ]
    )

    public static let testTarget = Target.capabilitiesTestTarget(name: "AlbumsUI")
}
