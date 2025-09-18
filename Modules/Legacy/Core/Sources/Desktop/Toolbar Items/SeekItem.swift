//  Created by Geoff Pado on 7/5/24.
//  Copyright © 2024 Cocoatype, LLC. All rights reserved.

#if targetEnvironment(macCatalyst)
import Foundation

class SeekItem: NSToolbarItem {
    static let identifier = NSToolbarItem.Identifier("SeekItem.identifier")
    let delegate: SeekItemDelegate

    init(delegate: SeekItemDelegate) {
        self.delegate = delegate
        super.init(itemIdentifier: Self.identifier)
        image = UIImage(systemName: "magnifyingglass")?.applyingSymbolConfiguration(.init(scale: .large))
        isBordered = true
        label = Strings.SeekItem.label

        target = delegate
        action = #selector(SeekItemDelegate.toggleSeeking(_:))
    }
}

@objc @MainActor protocol SeekItemDelegate: AnyObject {
    @objc func toggleSeeking(_ sender: NSToolbarItem)
}
#endif
