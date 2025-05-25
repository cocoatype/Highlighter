import ProjectDescription

public enum Shared {
    static let resources: [ResourceFileElement] = [
        "App/Resources/Assets.xcassets",
    ]

    public static let settings: Settings = .settings(base: [
        "CODE_SIGN_STYLE": "Manual",
        "CURRENT_PROJECT_VERSION": "0",
        "DERIVE_MACCATALYST_PRODUCT_BUNDLE_IDENTIFIER": "NO",
        "DEVELOPMENT_TEAM": "287EDDET2B",
        "ENABLE_HARDENED_RUNTIME[sdk=macosx*]": "YES",
        "IPHONEOS_DEPLOYMENT_TARGET": "14.0",
        "MACOSX_DEPLOYMENT_TARGET": "12.0",
        "MARKETING_VERSION": "999",
        "OTHER_CODE_SIGN_FLAGS": "--deep",
        "SWIFT_VERSION": "5.0",
        "SWIFT_MAX_VERSION_1500": "5.0",
        "SWIFT_MAX_VERSION_1600": "6.0",
        "SWIFT_MAX_VERSION": "$(SWIFT_MAX_VERSION_$(XCODE_VERSION_MAJOR))",
        "TARGETED_DEVICE_FAMILY": "1,2,6",
    ], debug: [
        "CODE_SIGN_IDENTITY": "Apple Development: Buddy Build (D47V8Y25W5)",
    ], release: [
        "CODE_SIGN_IDENTITY": "Apple Distribution",
    ])
}
