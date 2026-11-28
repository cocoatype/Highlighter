//  Created by Geoff Pado on 11/27/26.
//  Copyright © 2026 Cocoatype, LLC. All rights reserved.

#if os(macOS)
import AppKit
import Testing

@testable import MainMenu

@MainActor
struct MainMenuBuilderTests {
    private let menus = MainMenuBuilder.build(appName: "Black Highlighter")

    @Test func hasTheStandardMenusInOrder() {
        let titles = menus.main.items.map(\.title)

        #expect(titles == ["Black Highlighter", "File", "Edit", "View", "Window", "Help"])
    }

    @Test func exposesTheMenusAppKitManages() {
        let submenus = menus.main.items.compactMap(\.submenu)

        #expect(submenus[4] === menus.window)
        #expect(submenus[5] === menus.help)
        #expect(submenus[0].items.contains { $0.submenu === menus.services })
    }

    @Test func applicationMenuNamesTheApp() throws {
        let menu = try #require(menus.main.items.first?.submenu)

        #expect(menu.item(withTitle: "About Black Highlighter") != nil)
        #expect(menu.item(withTitle: "Hide Black Highlighter") != nil)
        #expect(menu.item(withTitle: "Quit Black Highlighter") != nil)
    }

    @Test(arguments: [
        Shortcut(#selector(NSApplication.orderFrontStandardAboutPanel(_:)), ""),
        Shortcut(#selector(NSApplication.hide(_:)), "h"),
        Shortcut(#selector(NSApplication.hideOtherApplications(_:)), "h", [.command, .option]),
        Shortcut(#selector(NSApplication.unhideAllApplications(_:)), ""),
        Shortcut(#selector(NSApplication.terminate(_:)), "q"),
        Shortcut(#selector(NSDocumentController.openDocument(_:)), "o"),
        Shortcut(#selector(NSWindow.performClose(_:)), "w"),
        Shortcut(Selector(("undo:")), "z"),
        Shortcut(Selector(("redo:")), "z", [.command, .shift]),
        Shortcut(#selector(NSText.cut(_:)), "x"),
        Shortcut(#selector(NSText.copy(_:)), "c"),
        Shortcut(#selector(NSText.paste(_:)), "v"),
        Shortcut(#selector(NSText.delete(_:)), ""),
        Shortcut(#selector(NSText.selectAll(_:)), "a"),
        Shortcut(#selector(NSWindow.toggleToolbarShown(_:)), "t", [.command, .option]),
        Shortcut(#selector(NSWindow.runToolbarCustomizationPalette(_:)), ""),
        Shortcut(#selector(NSWindow.toggleFullScreen(_:)), "f", [.command, .control]),
        Shortcut(#selector(NSWindow.performMiniaturize(_:)), "m"),
        Shortcut(#selector(NSWindow.performZoom(_:)), ""),
        Shortcut(#selector(NSApplication.arrangeInFront(_:)), ""),
    ])
    func standardItemsHaveTheirShortcuts(_ shortcut: Shortcut) throws {
        let item = try #require(allItems.first { $0.action == shortcut.action })

        #expect(item.keyEquivalent == shortcut.keyEquivalent)
        if !shortcut.keyEquivalent.isEmpty {
            #expect(item.keyEquivalentModifierMask == shortcut.modifiers)
        }
    }

    @Test func fileMenuOpensBeforeClosing() throws {
        let menu = try #require(menus.main.items[1].submenu)
        let actions = menu.items.compactMap(\.action)

        #expect(actions == [#selector(NSDocumentController.openDocument(_:)), #selector(NSWindow.performClose(_:))])
    }

    private var allItems: [NSMenuItem] {
        menus.main.items.compactMap(\.submenu).flatMap(\.items)
    }
}

struct Shortcut: Sendable, CustomTestStringConvertible {
    let action: Selector
    let keyEquivalent: String
    let modifiers: NSEvent.ModifierFlags

    init(_ action: Selector, _ keyEquivalent: String, _ modifiers: NSEvent.ModifierFlags = .command) {
        self.action = action
        self.keyEquivalent = keyEquivalent
        self.modifiers = modifiers
    }

    var testDescription: String { NSStringFromSelector(action) }
}
#endif
