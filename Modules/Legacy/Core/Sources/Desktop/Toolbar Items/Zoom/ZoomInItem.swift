//  Created by Geoff Pado on 9/2/25.
//  Copyright © 2025 Cocoatype, LLC. All rights reserved.

#if targetEnvironment(macCatalyst)
import Foundation

class ZoomInItem: NSToolbarItem {
    static let identifier = NSToolbarItem.Identifier("ZoomInItem.identifier")
    let delegate: ZoomItemDelegate

    init(delegate: ZoomItemDelegate) {
        self.delegate = delegate
        super.init(itemIdentifier: Self.identifier)

        image = UIImage(systemName: "plus.magnifyingglass")?
            .applyingSymbolConfiguration(.init(scale: .large))
        isBordered = true
        label = CoreStrings.ZoomInItem.label

        target = delegate
        action = #selector(ZoomItemDelegate.zoomIn(_:))
    }
}
#endif
