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
        destinations: [.iPhone, .iPad, .macCatalyst, .appleVisionWithiPadDesign],
        product: .appExtension,
        bundleId: "com.cocoatype.Highlighter.Photo",
        infoPlist: "Photo/Info.plist",
        buildableFolders: [
            .folder("Photo/Sources"),
            .folder("Photo/Resources"),
        ],
        dependencies: [
            .target(Editing.target),
            .target(ErrorHandling.target),
            .target(Exporting.target),
            .target(Redactions.target),
            .external(name: "FactoryKit"),
            .sdk(name: "PhotosUI", type: .framework),
        ],
        settings: .settings(
            base: [
                "ASSETCATALOG_COMPILER_GLOBAL_ACCENT_COLOR_NAME": "Accent Color",
                "ASSETCATALOG_COMPILER_APPICON_NAME": "AppIcon",
                "SKIP_INSTALL": "YES",
                "SWIFT_APPROACHABLE_CONCURRENCY": true,
            ],
            release: [
                "PROVISIONING_PROFILE_SPECIFIER": "Black Highlighter (iOS Photo Extension)",
            ],
            defaultSettings: .recommended(excluding: [
                "CODE_SIGN_IDENTITY",
            ])
        )
    )
}
