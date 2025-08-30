//
//  App.swift
//  HighlighterManifests
//
//  Created by Geoff Pado on 3/15/24.
//

import ProjectDescription

public enum App {
    public static let target = Target.target(
        name: "Highlighter",
        destinations: [.iPhone, .iPad, .macCatalyst, .appleVisionWithiPadDesign],
        product: .app,
        bundleId: "com.cocoatype.Highlighter",
        infoPlist: "App/Info.plist",
        sources: [
            "App/Sources/**",
        ],
        resources: .resources([
            "App/Resources/**",
        ] + Shared.resources),
        entitlements: "App/Highlighter.entitlements",
        dependencies: [
            .target(Action.target, condition: .when([.ios])),
            .target(Core.target),
            .target(Photo.target, condition: .when([.ios])),
            .target(Shortcuts.target),
            .target(Widgets.target, condition: .when([.ios])),
        ],
        settings: .settings(
            base: [
                "ASSETCATALOG_COMPILER_GLOBAL_ACCENT_COLOR_NAME": "Accent Color",
                "DERIVE_MACCATALYST_PRODUCT_BUNDLE_IDENTIFIER": "NO",
                "TARGETED_DEVICE_FAMILY": "1,2,6",
            ],
            debug: [
                "PROVISIONING_PROFILE_SPECIFIER": "match Development com.cocoatype.Highlighter",
                "PROVISIONING_PROFILE_SPECIFIER[sdk=macosx*]": "match Development com.cocoatype.Highlighter macos",
                "ENABLE_DEBUG_DYLIB": false,
            ], release: [
                "PROVISIONING_PROFILE_SPECIFIER": "match AppStore com.cocoatype.Highlighter",
                "PROVISIONING_PROFILE_SPECIFIER[sdk=macosx*]": "match AppStore com.cocoatype.Highlighter macos",
            ],
            defaultSettings: .recommended(excluding: [
                "CODE_SIGN_IDENTITY",
            ])
        )
    )
}
