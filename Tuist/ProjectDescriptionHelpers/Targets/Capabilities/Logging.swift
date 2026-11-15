import ProjectDescription

public enum Logging {
    public static let target = Target.capabilitiesTarget(
        name: "Logging",
        dependencies: [
            .external(name: "FactoryKit"),
            .external(name: "TelemetryClient"),
        ]
    )

    public static let testTarget = Target.capabilitiesTestTarget(
        name: "Logging",
        dependencies: [
            .external(name: "TelemetryClient"),
        ]
    )

    public static let doublesTarget = Target.capabilitiesDoublesTarget(
        name: "Logging",
        dependencies: [
            .target(TestHelpers.interfaceTarget),
        ],
    )
}
