import ProjectDescription

public enum SeekUI {
    public static let target = Target.capabilitiesTarget(
        name: "SeekUI",
        hasResources: true,
        dependencies: [
            .target(DesignSystem.target),
            .target(ErrorHandling.target),
            .external(name: "FactoryKit"),
        ]
    )

    public static let testTarget = Target.capabilitiesTestTarget(
        name: "SeekUI",
        dependencies: [
        ]
    )
}
