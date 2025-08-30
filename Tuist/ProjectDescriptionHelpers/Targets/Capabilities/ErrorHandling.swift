import ProjectDescription

public enum ErrorHandling {
    public static let target = Target.capabilitiesTarget(
        name: "ErrorHandling",
        usesMaxSwiftVersion: true,
        dependencies: [
            .target(Logging.target),
            .external(name: "FactoryKit"),
        ]
    )

    public static let testTarget = Target.capabilitiesTestTarget(
        name: "ErrorHandling",
        usesMaxSwiftVersion: true,
        dependencies: [
            .target(Logging.doublesTarget),
            .target(Logging.target),
            .external(name: "FactoryKit"),
            .external(name: "FactoryTesting"),
        ]
    )
}
