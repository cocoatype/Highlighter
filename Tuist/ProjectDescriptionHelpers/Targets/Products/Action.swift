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
        destinations: SDK.catalyst.destinations,
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
            .target(ErrorHandling.target(sdk: .catalyst)),
        ],
        settings: .settings(
            base: [
                "ASSETCATALOG_COMPILER_APPICON_NAME": "ActionIcon",
                "SKIP_INSTALL": "YES",
            ],
            debug: [
                "PROVISIONING_PROFILE_SPECIFIER": "match Development com.cocoatype.Highlighter.Action",
            ],
            release: [
                "PROVISIONING_PROFILE_SPECIFIER": "match AppStore com.cocoatype.Highlighter.Action",
            ],
            defaultSettings: .recommended(excluding: [
                "CODE_SIGN_IDENTITY",
            ])
        )
    )
}
