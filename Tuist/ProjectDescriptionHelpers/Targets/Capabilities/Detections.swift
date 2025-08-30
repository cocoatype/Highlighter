import ProjectDescription

public enum Detections {
    public static let target = Target.capabilitiesTarget(
        name: "Detections",
        usesMaxSwiftVersion: true,
        dependencies: [
            .target(ErrorHandling.target),
            .target(Observations.target),
        ]
    )

    public static let testTarget = Target.capabilitiesTestTarget(
        name: "Detections",
        usesMaxSwiftVersion: true,
        dependencies: [
        ]
    )
}
