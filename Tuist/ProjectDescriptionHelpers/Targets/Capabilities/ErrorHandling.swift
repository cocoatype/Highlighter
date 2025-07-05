import ProjectDescription

public enum ErrorHandling {
    public static func target(sdk: SDK) -> Target {
        Target.capabilitiesTarget(
            name: "ErrorHandling",
            sdk: sdk,
            dependencies: [
                .target(Logging.target(sdk: sdk)),
                .external(name: "FactoryKit"),
            ]
        )
    }

    public static let testTarget = Target.capabilitiesTestTarget(
        name: "ErrorHandling",
        dependencies: [
            .target(Logging.doublesTarget),
            .target(Logging.target(sdk: .catalyst)),
            .external(name: "FactoryKit"),
            .external(name: "FactoryTesting"),
        ]
    )
}
