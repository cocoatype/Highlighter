//  Created by Geoff Pado on 7/5/24.
//  Copyright © 2024 Cocoatype, LLC. All rights reserved.

#if targetEnvironment(macCatalyst)
import Foundation

class ColorPickerItem: NSToolbarItem {
    static let identifier = NSToolbarItem.Identifier("ColorPickerItem.identifier")
    let delegate: ColorPickerItemDelegate

    init(delegate: ColorPickerItemDelegate) {
        self.delegate = delegate
        super.init(itemIdentifier: Self.identifier)
        image = UIImage(systemName: "paintpalette")?.applyingSymbolConfiguration(.init(scale: .large))
        isBordered = true
        label = CoreStrings.ColorPickerItem.itemLabel

        target = delegate
        action = #selector(ColorPickerItemDelegate.displayColorPicker)
    }
}

@objc @MainActor protocol ColorPickerItemDelegate: AnyObject {
    var currentColor: UIColor { get }
    @objc func displayColorPicker(_ sender: NSToolbarItem)
}
#endif
