import ProjectDescription

public enum Tools {
    public static let target = Target.capabilitiesTarget(
        name: "Tools",
        hasResources: true,
        dependencies: [
            .target(DesignSystem.target),
        ]
    )

    public static let testTarget = Target.capabilitiesTestTarget(name: "Tools")
}
