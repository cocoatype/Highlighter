import ProjectDescription

public enum Brushes {
    public static let target = Target.capabilitiesTarget(
        name: "Brushes",
        hasResources: true,
        supportsNativeMac: true,
        dependencies: [
            .target(ErrorHandling.target),
            .target(Geometry.target),
            .external(name: "FactoryKit"),
        ]
    )

    public static let testTarget = Target.capabilitiesTestTarget(
        name: "Brushes",
        supportsNativeMac: true,
        dependencies: [
            .target(Geometry.target),
        ]
    )
}
