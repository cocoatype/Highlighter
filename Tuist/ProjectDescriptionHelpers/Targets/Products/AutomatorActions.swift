import ProjectDescription

public enum AutomatorActions {
    public static let target = Target.target(
        name: "AutomatorActions",
        destinations: [.mac],
        product: .automatorAction,
        bundleId: "com.cocoatype.Highlighter.Automator",
        infoPlist: "Automator/Info.plist",
        sources: ["Automator/Sources/**"],
        resources: ["Automator/Resources/**"],
        dependencies: [
            .target(Detections.target(sdk: .native)),
            .target(Logging.target(sdk: .native)),
            .target(Redactions.target(sdk: .native)),
            .target(Rendering.target(sdk: .native)),
            .external(name: "FactoryKit"),
        ],
        settings: .settings(base: [
            "LD_RUNPATH_SEARCH_PATHS": [
                "$(inherited)",
                "@executable_path/../Frameworks",
                "@loader_path/../Frameworks",
            ],
            "WRAPPER_EXTENSION": "action",
            "OTHER_OSAFLAGS": "-x -t 0 -c 0",
        ])
    )
}
