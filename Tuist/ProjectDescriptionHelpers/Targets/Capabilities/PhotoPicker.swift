import ProjectDescription

public enum PhotoPicker {
    public static let target = Target.capabilitiesTarget(
        name: "PhotoPicker",
        usesMaxSwiftVersion: true,
        dependencies: [
        ]
    )

    public static let testTarget = Target.capabilitiesTestTarget(
        name: "PhotoPicker",
        dependencies: [
        ]
    )
}
