//
//  Action.swift
//  ProjectDescriptionHelpers
//
//  Created by Geoff Pado on 3/15/24.
//

import ProjectDescription

public enum Action {
    public static let target = Target.target(
        name: "Action",
        destinations: [.iPhone, .iPad, .macCatalyst, .appleVisionWithiPadDesign],
        product: .appExtension,
        bundleId: "com.cocoatype.Highlighter.Action",
        infoPlist: "Action/Info.plist",
        sources: ["Action/Sources/**"],
        resources: .resources([
            "Action/Resources/**",
        ] + Shared.resources),
        entitlements: "Action/Action.entitlements",
        dependencies: [
            .target(DesignSystem.target),
            .target(Editing.target),
            .target(ErrorHandling.target),
            .external(name: "FactoryKit"),
        ],
        settings: .settings(
            base: [
                "ASSETCATALOG_COMPILER_APPICON_NAME": "ActionIcon",
                "ASSETCATALOG_COMPILER_GLOBAL_ACCENT_COLOR_NAME": "Accent Color",
                "SKIP_INSTALL": "YES",
            ],
            release: [
                "PROVISIONING_PROFILE_SPECIFIER": "Black Highlighter (Action Extension)",
            ],
            defaultSettings: .recommended(excluding: [
                "CODE_SIGN_IDENTITY",
            ])
        )
    )
}
