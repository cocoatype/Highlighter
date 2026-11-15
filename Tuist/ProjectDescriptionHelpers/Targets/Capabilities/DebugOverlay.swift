import ProjectDescription

public enum DebugOverlay {
    public static let target = Target.capabilitiesTarget(
        name: "DebugOverlay",
        dependencies: [
            .target(Defaults.target),
            .external(name: "FactoryKit"),
        ]
    )
}
