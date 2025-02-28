import ProjectDescription

public enum Shortcuts {
    public static let target = Target.capabilitiesTarget(
        name: "Shortcuts",
        hasResources: true,
        dependencies: [
            .target(AppNavigation.target),
            .target(DesignSystem.target),
            .target(Detections.target(sdk: .catalyst)),
            .target(Observations.target(sdk: .catalyst)),
            .target(Purchasing.target),
            .target(Redactions.target(sdk: .catalyst)),
            .target(Rendering.target(sdk: .catalyst)),
        ]
    )

    public static let testTarget = Target.capabilitiesTestTarget(
        name: "Shortcuts",
        dependencies: [
            .target(Detections.target(sdk: .catalyst)),
            .target(Observations.target(sdk: .catalyst)),
            .target(Purchasing.doublesTarget),
            .target(Redactions.target(sdk: .catalyst)),
        ]
    )
}
