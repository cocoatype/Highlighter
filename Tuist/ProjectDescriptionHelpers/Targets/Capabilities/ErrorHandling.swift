import ProjectDescription

public enum ErrorHandling {
    public static let target = Target.capabilitiesTarget(
        name: "ErrorHandling",
        dependencies: [
            .target(Logging.target),
            .external(name: "FactoryKit"),
        ]
    )

    public static let testTarget = Target.capabilitiesTestTarget(
        name: "ErrorHandling",
        dependencies: [
            .target(Logging.doublesTarget),
            .target(Logging.target),
            .external(name: "FactoryKit"),
            .external(name: "FactoryTesting"),
        ]
    )
}
