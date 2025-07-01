import ProjectDescription

public enum AppRatings {
    public static let target = Target.capabilitiesTarget(
        name: "AppRatings",
        dependencies: [
            .target(Defaults.target),
            .target(ErrorHandling.target(sdk: .catalyst)),
            .target(Logging.target(sdk: .catalyst)),
            .target(Purchasing.target),
            .target(PurchaseMarketing.target),
        ]
    )

    public static let testTarget = Target.capabilitiesTestTarget(
        name: "AppRatings",
        dependencies: [
            .target(Defaults.target),
            .target(Defaults.doublesTarget),
            .target(Editing.target),
            .target(Logging.doublesTarget),
            .target(Logging.target(sdk: .catalyst)),
            .target(TestHelpers.target),
        ]
    )
}
