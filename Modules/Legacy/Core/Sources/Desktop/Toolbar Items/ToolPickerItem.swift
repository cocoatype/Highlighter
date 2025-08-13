//  Created by Geoff Pado on 7/5/24.
//  Copyright © 2024 Cocoatype, LLC. All rights reserved.

#if targetEnvironment(macCatalyst)
import AppKit
import Editing
import Tools
import UIKit

class ToolPickerItem: NSMenuToolbarItem {
    static let identifier = NSToolbarItem.Identifier("ToolPickerItem.identifier")
    let delegate: ToolPickerItemDelegate

    init(delegate: ToolPickerItemDelegate) {
        self.delegate = delegate
        super.init(itemIdentifier: Self.identifier)
        image = selectedToolImage
        label = Strings.itemLabel
        itemMenu = currentMenu
    }

    private var currentMenu: UIMenu {
        UIMenu(title: Strings.menuTitle, children: HighlighterTool.allCases.map { Command(tool: $0, currentTool: delegate.highlighterTool) })
    }

    private var selectedToolImage: UIImage? {
        switch delegate.highlighterTool {
        case .magic: return HighlighterTool.magic.image.applyingSymbolConfiguration(.init(scale: .large))
        case .lasso: return HighlighterTool.lasso.image.applyingSymbolConfiguration(.init(scale: .large))
        case .manual: return HighlighterTool.manual.image.applyingSymbolConfiguration(.init(scale: .large))
        case .eraser: return HighlighterTool.eraser.image.applyingSymbolConfiguration(.init(scale: .large))
        }
    }

    override func validate() {
        image = selectedToolImage
        itemMenu = currentMenu
    }

    private typealias Strings = CoreStrings.ToolPickerItem

    private class Command: UICommand {
        convenience init(tool: HighlighterTool, currentTool: HighlighterTool) {
            self.init(title: Self.title(for: tool), image: tool.image, action: #selector(PhotoEditingViewController.selectHighlighterTool(_:)), propertyList: HighlighterTool.allCases.firstIndex(of: tool), state: (currentTool == tool ? .on : .off))
        }

        static func title(for tool: HighlighterTool) -> String {
            switch tool {
            case .magic: Strings.magicToolItem
            case .lasso: Strings.lassoToolItem
            case .manual: Strings.manualToolItem
            case .eraser: Strings.eraserToolItem
            }
        }

        @available(*, unavailable)
        required init(coder: NSCoder) {
            let typeName = NSStringFromClass(type(of: self))
            fatalError("\(typeName) does not implement init(coder:)")
        }
    }
}

@MainActor protocol ToolPickerItemDelegate: AnyObject {
    var highlighterTool: HighlighterTool { get }
}
#endif
