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
        image = UIImage(systemName: "highlighter")
        label = NSLocalizedString("ToolPickerItem.label", comment: "Label for the share toolbar item")
        itemMenu = currentMenu
    }

    private var currentMenu: UIMenu {
        UIMenu(title: "Tools", children: [
            UICommand(title: "Magic Highlighter", image: UIImage(systemName: "highlighter"), action: #selector(BasePhotoEditingViewController.selectMagicHighlighter), state: (delegate.highlighterTool == .magic ? .on : .off)),
            UICommand(title: "Manual Highlighter", image: UIImage(systemName: "highlighter"), action: #selector(BasePhotoEditingViewController.selectManualHighlighter), state: (delegate.highlighterTool == .manual ? .on : .off))
        ])
    }

    override func validate() {
        itemMenu = currentMenu
    }
}

protocol ToolPickerItemDelegate: class {
    var highlighterTool: HighlighterTool { get }
}
#endif
