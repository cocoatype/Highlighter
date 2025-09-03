//  Created by Geoff Pado on 9/2/25.
//  Copyright © 2025 Cocoatype, LLC. All rights reserved.

#if targetEnvironment(macCatalyst)
import Foundation

class ZoomOutItem: NSToolbarItem {
    static let identifier = NSToolbarItem.Identifier("ZoomOutItem.identifier")
    let delegate: ZoomItemDelegate

    init(delegate: ZoomItemDelegate) {
        self.delegate = delegate
        super.init(itemIdentifier: Self.identifier)

        image = UIImage(systemName: "minus.magnifyingglass")?
            .applyingSymbolConfiguration(.init(scale: .large))
        isBordered = true
        label = CoreStrings.ZoomOutItem.label

        target = delegate
        action = #selector(ZoomItemDelegate.zoomOut(_:))
    }
}
#endif
