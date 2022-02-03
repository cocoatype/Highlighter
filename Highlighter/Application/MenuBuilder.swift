//  Created by Geoff Pado on 1/31/22.
//  Copyright © 2022 Cocoatype, LLC. All rights reserved.

#if targetEnvironment(macCatalyst)

import Editing
import UIKit

enum MenuBuilder {
    static func buildMenu(with builder: UIMenuBuilder) {
        guard builder.system == .main else { return }

        builder.replaceChildren(ofMenu: .close) { existingChildren in
            existingChildren + [
                UIKeyCommand(title: Self.saveMenuItemTitle, action: #selector(PhotoEditingViewController.save(_:)), input: "S", modifierFlags: [.command]),
                UIKeyCommand(title: Self.saveAsMenuItemTitle, action: #selector(PhotoEditingViewController.saveAs(_:)), input: "S", modifierFlags: [.command, .shift])
            ]
        }

        #if targetEnvironment(macCatalyst)
        if FeatureFlag.newFromClipboard {
            builder.replaceChildren(ofMenu: .newScene) {
                $0 + [NewFromClipboardCommand()]
            }
        }
        #endif

        let recentsMenuDataSource = RecentsMenuDataSource()
        builder.replace(menu: .openRecent, with: recentsMenuDataSource.recentsMenu)

        let findMenu = UIMenu(options: .displayInline, children: [
            UIKeyCommand(title: Self.findMenuItemTitle, action: #selector(PhotoEditingViewController.startSeeking(_:)), input: "F", modifierFlags: [.command])
        ])
        builder.insertSibling(findMenu, beforeMenu: .spelling)

        let helpMenuDataSource = HelpMenuDataSource()
        builder.insertChild(helpMenuDataSource.helpMenu, atStartOfMenu: .help)

        let preferencesMenu = UIMenu(options: .displayInline, children: [
            UIKeyCommand(title: Self.preferencesMenuItemTitle, action: #selector(AppDelegate.displayPreferences), input: ",", modifierFlags: [.command])
        ])
        builder.insertSibling(preferencesMenu, afterMenu: .about)
    }

    private static let saveMenuItemTitle = NSLocalizedString("AppDelegate.saveMenuTitle", comment: "Save menu title")
    private static let saveAsMenuItemTitle = NSLocalizedString("AppDelegate.saveAsMenuTitle", comment: "Save As menu title")

    private static let preferencesMenuTitle = NSLocalizedString("AppDelegate.preferencesMenuTitle", comment: "Preferences menu title")
    private static let preferencesMenuItemTitle = NSLocalizedString("AppDelegate.preferencesMenuItemTitle", comment: "Preferences menu item title")

    private static let findMenuItemTitle = NSLocalizedString("MenuBuilder.findMenuItemTitle", comment: "Find menu item title")
}

#endif
