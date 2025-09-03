import ProjectDescription

public enum BarBuilder {
    public static let target = Target.capabilitiesTarget(
        name: "BarBuilder",
        dependencies: [
        ]
    )

    public static let testTarget = Target.capabilitiesTestTarget(
        name: "BarBuilder",
        dependencies: [
        ]
    )
}
