import ProjectDescription

public enum URLParsing {
    public static let target = Target.capabilitiesTarget(
        name: "URLParsing",
        supportsNativeMac: true,
        dependencies: [
        ]
    )

    public static let testTarget = Target.capabilitiesTestTarget(
        name: "URLParsing",
        hasResources: true,
        supportsNativeMac: true,
    )
}
