import ProjectDescription

public enum AppNavigation {
    public static let target = Target.capabilitiesTarget(
        name: "AppNavigation",
        usesMaxSwiftVersion: true,
        dependencies: [
            .target(AlbumsData.target),
            .target(Redactions.target(sdk: .catalyst)),
        ]
    )

    public static let doublesTarget = Target.capabilitiesDoublesTarget(
        name: "AppNavigation"
    )
}
