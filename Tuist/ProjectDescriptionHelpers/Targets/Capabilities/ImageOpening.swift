import ProjectDescription

public enum ImageOpening {
    public static let target = Target.capabilitiesTarget(
        name: "ImageOpening",
        usesMaxSwiftVersion: true,
        dependencies: [
        ]
    )

    public static let testTarget = Target.capabilitiesTestTarget(
        name: "ImageOpening",
        dependencies: [
        ]
    )
}
