import ProjectDescription

public enum AlbumsData {
    public static let target = Target.capabilitiesTarget(
        name: "AlbumsData",
        hasResources: true,
        usesMaxSwiftVersion: true,
        dependencies: [
            .target(DesignSystem.target),
            .target(ErrorHandling.target),
        ]
    )

    public static let testTarget = Target.capabilitiesTestTarget(name: "AlbumsData")
}
