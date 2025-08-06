import ProjectDescription

public enum AlbumsData {
    public static let target = Target.capabilitiesTarget(
        name: "AlbumsData",
        hasResources: true,
        usesMaxSwiftVersion: false,
        dependencies: [
            .target(DesignSystem.target),
            .target(ErrorHandling.target(sdk: .catalyst)),
        ]
    )

    public static let testTarget = Target.capabilitiesTestTarget(name: "AlbumsData")
}
