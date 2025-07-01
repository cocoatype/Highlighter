import ProjectDescription

public enum DebugOverlay {
    public static let target = Target.capabilitiesTarget(
        name: "DebugOverlay",
        usesMaxSwiftVersion: true,
        dependencies: [
            .target(Defaults.target),
            .target(DesignSystem.target),
            .external(name: "FactoryKit"),
        ]
    )
}
