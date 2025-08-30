import ProjectDescription

public enum DesignSystem {
    public static let target = Target.capabilitiesTarget(
        name: "DesignSystem",
        hasResources: true,
        usesMaxSwiftVersion: true,
        dependencies: [
            .target(ErrorHandling.target),
            .external(name: "SwiftUIIntrospect-Dynamic"),
        ]
    )

    public static let doublesTarget = Target.capabilitiesDoublesTarget(name: "DesignSystem")
}
