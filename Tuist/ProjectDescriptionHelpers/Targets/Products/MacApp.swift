//  Created by Geoff Pado on 11/26/26.
//  Copyright © 2026 Cocoatype, LLC. All rights reserved.

import ProjectDescription

/// The native AppKit app. It isn't shipped yet; the Catalyst build in
/// `App` remains the Mac app until the cutover (#487).
public enum MacApp {
    public static let target = Target.target(
        name: "HighlighterMac",
        destinations: [.mac],
        product: .app,
        bundleId: "com.cocoatype.Highlighter",
        deploymentTargets: .macOS("13.0"),
        infoPlist: "Mac/Info.plist",
        resources: [
            "App/Resources/AppIcon.icon",
        ],
        buildableFolders: [
            .folder("Mac/Sources"),
        ],
        entitlements: "Mac/HighlighterMac.entitlements",
        dependencies: [
            .target(Documents.target),
        ],
        settings: .settings(
            base: [
                "SWIFT_APPROACHABLE_CONCURRENCY": true,
                "SWIFT_UPCOMING_FEATURE_EXISTENTIAL_ANY": true,
            ],
            debug: [
                "CODE_SIGN_IDENTITY": .string(Shared.debugCodeSignIdentity),
                "ENABLE_DEBUG_DYLIB": false,
            ],
            release: [
                "PROVISIONING_PROFILE_SPECIFIER": "Black Highlighter (macOS Non-Catalyst App)",
            ],
            defaultSettings: .recommended(excluding: [
                "CODE_SIGN_IDENTITY",
            ])
        )
    )
}
