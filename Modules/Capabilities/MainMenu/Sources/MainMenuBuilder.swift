//  Created by Geoff Pado on 11/27/26.
//  Copyright © 2026 Cocoatype, LLC. All rights reserved.

#if os(macOS)
import AppKit

/// Builds the AppKit app's main menu: the application, File, Edit, View,
/// Window and Help menus with their standard items. Feature commands are
/// added with their features.
@MainActor
public enum MainMenuBuilder {
    /// Builds the main menu and installs it in `application`, including the
    /// Services, Window and Help menus that AppKit manages.
    public static func install(in application: NSApplication) {
        let menus = build(appName: appName(in: .main))
        application.mainMenu = menus.main
        application.servicesMenu = menus.services
        application.windowsMenu = menus.window
        application.helpMenu = menus.help
    }

    struct Menus {
        let main: NSMenu
        let services: NSMenu
        let window: NSMenu
        let help: NSMenu
    }

    static func build(appName: String) -> Menus {
        let services = NSMenu(title: Strings.MainMenuBuilder.servicesMenuTitle)
        let window = windowMenu()
        let help = NSMenu(title: Strings.MainMenuBuilder.helpMenuTitle)

        let main = NSMenu()
        for submenu in [
            applicationMenu(appName: appName, services: services),
            fileMenu(),
            editMenu(),
            viewMenu(),
            window,
            help,
        ] {
            let item = NSMenuItem(title: submenu.title, action: nil, keyEquivalent: "")
            item.submenu = submenu
            main.addItem(item)
        }

        return Menus(main: main, services: services, window: window, help: help)
    }

    static func appName(in bundle: Bundle) -> String {
        let name = bundle.object(forInfoDictionaryKey: "CFBundleDisplayName")
            ?? bundle.object(forInfoDictionaryKey: "CFBundleName")
        return name as? String ?? ProcessInfo.processInfo.processName
    }

    // MARK: Menus

    private static func applicationMenu(appName: String, services: NSMenu) -> NSMenu {
        let servicesItem = NSMenuItem(title: services.title, action: nil, keyEquivalent: "")
        servicesItem.submenu = services

        let hideOthersItem = item(
            Strings.MainMenuBuilder.hideOthersItemTitle,
            #selector(NSApplication.hideOtherApplications(_:)),
            "h",
            [.command, .option]
        )

        // The application menu's title is replaced by the app name in the menu bar.
        return menu(appName, items: [
            item(
                Strings.MainMenuBuilder.aboutItemTitleFormat(appName),
                #selector(NSApplication.orderFrontStandardAboutPanel(_:))
            ),
            .separator(),
            servicesItem,
            .separator(),
            item(Strings.MainMenuBuilder.hideItemTitleFormat(appName), #selector(NSApplication.hide(_:)), "h"),
            hideOthersItem,
            item(Strings.MainMenuBuilder.showAllItemTitle, #selector(NSApplication.unhideAllApplications(_:))),
            .separator(),
            item(Strings.MainMenuBuilder.quitItemTitleFormat(appName), #selector(NSApplication.terminate(_:)), "q"),
        ])
    }

    private static func fileMenu() -> NSMenu {
        menu(Strings.MainMenuBuilder.fileMenuTitle, items: [
            item(Strings.MainMenuBuilder.openItemTitle, #selector(NSDocumentController.openDocument(_:)), "o"),
            .separator(),
            item(Strings.MainMenuBuilder.closeItemTitle, #selector(NSWindow.performClose(_:)), "w"),
        ])
    }

    private static func editMenu() -> NSMenu {
        menu(Strings.MainMenuBuilder.editMenuTitle, items: [
            item(Strings.MainMenuBuilder.undoItemTitle, Selector(("undo:")), "z"),
            item(Strings.MainMenuBuilder.redoItemTitle, Selector(("redo:")), "z", [.command, .shift]),
            .separator(),
            item(Strings.MainMenuBuilder.cutItemTitle, #selector(NSText.cut(_:)), "x"),
            item(Strings.MainMenuBuilder.copyItemTitle, #selector(NSText.copy(_:)), "c"),
            item(Strings.MainMenuBuilder.pasteItemTitle, #selector(NSText.paste(_:)), "v"),
            item(Strings.MainMenuBuilder.deleteItemTitle, #selector(NSText.delete(_:))),
            item(Strings.MainMenuBuilder.selectAllItemTitle, #selector(NSText.selectAll(_:)), "a"),
        ])
    }

    private static func viewMenu() -> NSMenu {
        menu(Strings.MainMenuBuilder.viewMenuTitle, items: [
            item(
                Strings.MainMenuBuilder.showToolbarItemTitle,
                #selector(NSWindow.toggleToolbarShown(_:)),
                "t",
                [.command, .option]
            ),
            item(
                Strings.MainMenuBuilder.customizeToolbarItemTitle,
                #selector(NSWindow.runToolbarCustomizationPalette(_:))
            ),
            .separator(),
            item(
                Strings.MainMenuBuilder.enterFullScreenItemTitle,
                #selector(NSWindow.toggleFullScreen(_:)),
                "f",
                [.command, .control]
            ),
        ])
    }

    private static func windowMenu() -> NSMenu {
        menu(Strings.MainMenuBuilder.windowMenuTitle, items: [
            item(Strings.MainMenuBuilder.minimizeItemTitle, #selector(NSWindow.performMiniaturize(_:)), "m"),
            item(Strings.MainMenuBuilder.zoomItemTitle, #selector(NSWindow.performZoom(_:))),
            .separator(),
            item(
                Strings.MainMenuBuilder.bringAllToFrontItemTitle,
                #selector(NSApplication.arrangeInFront(_:))
            ),
        ])
    }

    // MARK: Helpers

    private static func menu(_ title: String, items: [NSMenuItem]) -> NSMenu {
        let menu = NSMenu(title: title)
        menu.items = items
        return menu
    }

    private static func item(
        _ title: String,
        _ action: Selector,
        _ keyEquivalent: String = "",
        _ modifiers: NSEvent.ModifierFlags = .command
    ) -> NSMenuItem {
        let item = NSMenuItem(title: title, action: action, keyEquivalent: keyEquivalent)
        item.keyEquivalentModifierMask = modifiers
        return item
    }
}
#endif
