import ProjectDescription

public enum PhotoGallery {
    public static let target = Target.capabilitiesTarget(
        name: "PhotoGallery",
        dependencies: [
            .target(AlbumsData.target),
            .target(AppNavigation.target),
            .target(PhotoPermissions.target),
            .target(Redactions.target(sdk: .catalyst)),
            .external(name: "FactoryKit"),
        ]
    )

    public static let testTarget = Target.capabilitiesTestTarget(
        name: "PhotoGallery",
        dependencies: [
            .external(name: "FactoryKit"),
            .external(name: "FactoryTesting"),
        ]
    )
}
