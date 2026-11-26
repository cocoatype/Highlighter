import ProjectDescription

public enum DesignSystem {
    public static let target = Target.capabilitiesTarget(
        name: "DesignSystem",
        hasResources: true,
        supportsNativeMac: true,
        dependencies: [
            .target(ErrorHandling.target),
        ]
    )

    public static let doublesTarget = Target.capabilitiesDoublesTarget(
        name: "DesignSystem",
        supportsNativeMac: true,
    )
}
