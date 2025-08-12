import ProjectDescription

public enum MobileAutoRedactionsUI {
    public static let target = Target.capabilitiesTarget(
        name: "MobileAutoRedactionsUI",
        hasResources: true,
        usesMaxSwiftVersion: true,
        dependencies: [
            .target(Defaults.target),
            .target(DesignSystem.target),
            .target(Detections.target(sdk: .catalyst)),
            .target(ErrorHandling.target(sdk: .catalyst)),
            .target(Logging.target(sdk: .catalyst)),
            .external(name: "FactoryKit"),
        ]
    )

    public static let testTarget = Target.capabilitiesTestTarget(
        name: "MobileAutoRedactionsUI",
        usesMaxSwiftVersion: true,
    )
}
