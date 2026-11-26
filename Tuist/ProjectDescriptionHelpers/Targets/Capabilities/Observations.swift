import ProjectDescription

public enum Observations {
    public static let target = Target.capabilitiesTarget(
        name: "Observations",
        supportsNativeMac: true,
        dependencies: [
            .target(Geometry.target),
        ]
    )

    public static let testTarget = Target.capabilitiesTestTarget(
        name: "Observations",
        supportsNativeMac: true,
        dependencies: [
            .target(Geometry.target),
        ]
    )
}
