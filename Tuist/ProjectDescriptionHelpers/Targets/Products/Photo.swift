//
//  Photo.swift
//  ProjectDescriptionHelpers
//
//  Created by Geoff Pado on 3/15/24.
//

import ProjectDescription

public enum Photo {
    public static let target = Target.target(
        name: "Photo",
        destinations: SDK.catalyst.destinations,
        product: .appExtension,
        bundleId: "com.cocoatype.Highlighter.Photo",
        infoPlist: "Photo/Info.plist",
        sources: ["Photo/Sources/**"],
        resources: .resources([
            "Photo/Resources/**",
        ] + Shared.resources),
        dependencies: [
            .target(Editing.target),
            .target(ErrorHandling.target(sdk: .catalyst)),
            .target(Exporting.target),
            .target(Redactions.target(sdk: .catalyst)),
            .external(name: "FactoryKit"),
            .sdk(name: "PhotosUI", type: .framework),
        ],
        settings: .settings(
            base: [
                "ASSETCATALOG_COMPILER_GLOBAL_ACCENT_COLOR_NAME": "Accent Color",
                "ASSETCATALOG_COMPILER_APPICON_NAME": "AppIcon",
                "SKIP_INSTALL": "YES",
            ],
            debug: [
                "PROVISIONING_PROFILE_SPECIFIER": "match Development com.cocoatype.Highlighter.Photo",
            ],
            release: [
                "PROVISIONING_PROFILE_SPECIFIER": "match AppStore com.cocoatype.Highlighter.Photo",
            ],
            defaultSettings: .recommended(excluding: [
                "CODE_SIGN_IDENTITY",
            ])
        )
    )
}
