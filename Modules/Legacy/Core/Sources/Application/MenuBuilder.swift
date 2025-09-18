//  Created by Geoff Pado on 1/31/22.
//  Copyright © 2022 Cocoatype, LLC. All rights reserved.

#if targetEnvironment(macCatalyst)
import Editing
import UIKit

@MainActor enum MenuBuilder {
    static func buildMenu(with builder: UIMenuBuilder) {
        guard builder.system == .main else { return }

        let documentChildren = [
            saveMenuItem,
            saveAsMenuItem,
        ]

        if #available(macCatalyst 16.0, *) {
            builder.replaceChildren(ofMenu: .document) { _ in documentChildren }
        } else {
            builder.insertSibling(UIMenu(options: .displayInline, children: documentChildren), afterMenu: .close)
        }

        #if targetEnvironment(macCatalyst)
        builder.replaceChildren(ofMenu: .newScene) {
            $0 + [NewFromClipboardCommand()]
        }
        #endif

        let recentsMenuDataSource = RecentsMenuDataSource()
        builder.replace(menu: .openRecent, with: recentsMenuDataSource.recentsMenu)

        let findMenu = UIMenu(
            options: .displayInline,
            children: [findMenuItem]
        )
        builder.insertSibling(findMenu, beforeMenu: .spelling)

        let helpMenuDataSource = HelpMenuDataSource()
        builder.replaceChildren(ofMenu: .help) { _ in
            helpMenuDataSource.helpMenu.children
        }

        let preferencesMenu = UIMenu(
            options: .displayInline,
            children: [preferencesMenuItem]
        )
        builder.insertSibling(preferencesMenu, afterMenu: .about)
    }

    private static let saveMenuItem = UIKeyCommand(
        title: Strings.MenuBuilder.saveMenuItemTitle,
        action: #selector(PhotoEditingViewController.save(_:)),
        input: "S",
        modifierFlags: [.command]
    )

    private static let saveAsMenuItem = UIKeyCommand(
        title: Strings.MenuBuilder.saveAsMenuItemTitle,
        action: #selector(PhotoEditingViewController.saveAs(_:)),
        input: "S",
        modifierFlags: [.command, .shift]
    )

    private static let findMenuItem = UIKeyCommand(
        title: Strings.MenuBuilder.findMenuItemTitle,
        action: #selector(PhotoEditingViewController.startSeeking(_:)),
        input: "F",
        modifierFlags: [.command]
    )

    private static let preferencesMenuItem = UIKeyCommand(
        title: Strings.MenuBuilder.preferencesMenuItemTitle,
        action: #selector(AppDelegate.displayPreferences),
        input: ",",
        modifierFlags: [.command]
    )
}

#endif
