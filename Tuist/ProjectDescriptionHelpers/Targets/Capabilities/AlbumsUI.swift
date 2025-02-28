import ProjectDescription

public enum AlbumsUI {
    public static let target = Target.capabilitiesTarget(
        name: "AlbumsUI",
        hasResources: true,
        dependencies: [
            .target(AlbumsData.target),
            .target(AppNavigation.target),
            .target(DesignSystem.target),
            .target(Redactions.target(sdk: .catalyst)),
            .external(name: "SwiftUIIntrospect"),
        ]
    )

    public static let testTarget = Target.capabilitiesTestTarget(name: "AlbumsUI")
}
