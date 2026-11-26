import ProjectDescription

public enum EditingEngine {
    public static let target = Target.capabilitiesTarget(
        name: "EditingEngine",
        supportsNativeMac: true,
        dependencies: [
            .target(Observations.target),
        ]
    )

    public static let testTarget = Target.capabilitiesTestTarget(
        name: "EditingEngine",
        supportsNativeMac: true,
        dependencies: [
            .target(Geometry.target),
            .target(Observations.target),
        ]
    )
}
