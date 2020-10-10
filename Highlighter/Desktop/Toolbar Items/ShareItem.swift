//  Created by Geoff Pado on 8/3/20.
//  Copyright © 2020 Cocoatype, LLC. All rights reserved.

import Editing
import UIKit
import UniformTypeIdentifiers

#if targetEnvironment(macCatalyst)
class ShareItem: NSSharingServicePickerToolbarItem, UIActivityItemsConfigurationReading {
    static let identifier = NSToolbarItem.Identifier("ShareItem.identifier")

    init(delegate: ShareItemDelegate?) {
        self.delegate = delegate
        super.init(itemIdentifier: Self.identifier)

        image = UIImage(systemName: "square.and.arrow.up")
        label = NSLocalizedString("ShareItem.label", comment: "Label for the share toolbar item")
        isEnabled = true

        activityItemsConfiguration = self
    }

    weak var delegate: ShareItemDelegate?

    var itemProvidersForActivityItemsConfiguration: [NSItemProvider] {
        guard let delegate = delegate, delegate.canExportImage else { return [] }

        let itemProvider = NSItemProvider()
        itemProvider.registerItem(forTypeIdentifier: UTType.image.identifier) { [weak self] completionHandler, itemClass, options in
            self?.delegate?.exportImage { image in
                guard let completionHandler = completionHandler else { return }
                guard let imageData = image?.pngData() else { return completionHandler(nil, nil) }
                completionHandler((imageData as NSData), nil)
                self?.delegate?.didExportImage()
            }
        }

        return [itemProvider]
    }
}

protocol ShareItemDelegate: class {
    var canExportImage: Bool { get }
    func exportImage(_ completionHandler: @escaping ((UIImage?) -> Void))
    func didExportImage()
}

class ToolPickerItem: NSMenuToolbarItem {
    static let identifier = NSToolbarItem.Identifier("ToolPickerItem.identifier")
    let delegate: ToolPickerItemDelegate

    init(delegate: ToolPickerItemDelegate) {
        self.delegate = delegate
        super.init(itemIdentifier: Self.identifier)
        image = selectedToolImage
        label = Self.itemLabel
        itemMenu = currentMenu
    }

    private var currentMenu: UIMenu {
        UIMenu(title: Self.menuTitle, children: [
            UICommand(title: Self.magicToolItem, image: UIImage(named: "highlighter.magic"), action: #selector(BasePhotoEditingViewController.selectMagicHighlighter), state: (delegate.highlighterTool == .magic ? .on : .off)),
            UICommand(title: Self.manualToolItem, image: UIImage(systemName: "highlighter"), action: #selector(BasePhotoEditingViewController.selectManualHighlighter), state: (delegate.highlighterTool == .manual ? .on : .off))
        ])
    }

    private var selectedToolImage: UIImage? {
        switch delegate.highlighterTool {
        case .magic: return UIImage(named: "highlighter.magic")?.applyingSymbolConfiguration(.init(scale: .large))
        case .manual: return UIImage(systemName: "highlighter")?.applyingSymbolConfiguration(.init(scale: .large))
        }
    }

    override func validate() {
        image = selectedToolImage
        itemMenu = currentMenu
    }

    // MARK: Boilerplate
    private static let itemLabel = NSLocalizedString("ToolPickerItem.itemLabel", comment: "Label for the tools toolbar item")
    private static let menuTitle = NSLocalizedString("ToolPickerItem.menuTitle", comment: "Title for the tools toolbar menu")
    private static let magicToolItem = NSLocalizedString("ToolPickerItem.magicToolItem", comment: "Menu item for the magic highlighter tool")
    private static let manualToolItem = NSLocalizedString("ToolPickerItem.manualToolItem", comment: "Menu item for the manual highlighter tool")
}

protocol ToolPickerItemDelegate: class {
    var highlighterTool: HighlighterTool { get }
}

class ColorPickerItem: NSToolbarItem {
    static let identifier = NSToolbarItem.Identifier("ColorPickerItem.identifier")
    let delegate: ColorPickerItemDelegate

    init(delegate: ColorPickerItemDelegate) {
        self.delegate = delegate
        super.init(itemIdentifier: Self.identifier)
        image = UIImage(systemName: "paintpalette")?.applyingSymbolConfiguration(.init(scale: .large))
        label = Self.itemLabel

        target = delegate
        action = #selector(ColorPickerItemDelegate.displayColorPicker)
    }

    // MARK: Boilerplate
    private static let itemLabel = NSLocalizedString("ColorPickerItem.itemLabel", comment: "Label for the color picker toolbar item")
}

@objc protocol ColorPickerItemDelegate: class {
    var currentColor: UIColor { get }
    @objc func displayColorPicker(_ sender: NSToolbarItem)
}

#endif
