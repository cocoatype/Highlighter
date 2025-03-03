import ProjectDescription

public enum PhotoPermissions {
    public static let target = Target.capabilitiesTarget(
        name: "PhotoPermissions",
        hasResources: true,
        usesMaxSwiftVersion: true,
        dependencies: [
            .target(DesignSystem.target),
        ]
    )

    public static let testTarget = Target.capabilitiesTestTarget(
        name: "PhotoPermissions",
        dependencies: [
        ]
    )
}
