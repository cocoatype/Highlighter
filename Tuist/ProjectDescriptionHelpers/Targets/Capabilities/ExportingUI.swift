import ProjectDescription

public enum ExportingUI {
    public static let target = Target.capabilitiesTarget(
        name: "ExportingUI",
        hasResources: true,
        dependencies: [
            .target(DesignSystem.target),
            .target(ErrorHandling.target),
            .target(Exporting.target),
            .target(Redactions.target),
            .external(name: "FactoryKit"),
        ]
    )
}
