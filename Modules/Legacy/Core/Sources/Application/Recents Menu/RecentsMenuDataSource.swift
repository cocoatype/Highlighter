//  Created by Geoff Pado on 2/13/21.
//  Copyright © 2021 Cocoatype, LLC. All rights reserved.

import Defaults
import Editing
import UIKit

#if targetEnvironment(macCatalyst)
class RecentsMenuDataSource: NSObject {
    static func addRecentItem(_ url: URL) {
        Defaults.addRecentBookmark(url)
        UIMenuSystem.main.setNeedsRebuild()
    }

    static func clearRecentItems() {
        Defaults.clearRecentBookmarks()
        UIMenuSystem.main.setNeedsRebuild()
    }

    var recentsMenu: UIMenu {
        UIMenu(title: Self.menuTitle, identifier: nil, children: menuItems + [clearMenu])
    }

    private var menuItems: [UIMenuElement] {
        recentItemsURLs.map { url in
            UICommand(title: url.lastPathComponent, image: icon(for: url), action: #selector(AppDelegate.openRecentFile(_:)), propertyList: url.path)
        }
    }

    private static let clearMenuItemTitle = NSLocalizedString("RecentsMenuDataSource.clearMenuItemTitle", comment: "Title for the clear recents menu item")
    private let clearMenu = UIMenu(options: .displayInline, children: [
        UICommand(title: RecentsMenuDataSource.clearMenuItemTitle, action: #selector(AppDelegate.clearRecents))
    ])

    private func icon(for url: URL) -> UIImage? {
        let cgImage = FileIconFetcher().icon(for: url).takeUnretainedValue()
        return UIImage(cgImage: cgImage, scale: UIScreen.main.scale, orientation: .up)
    }

    private var recentItemsURLs: [URL] {
        var bool = false
        return Defaults.recentBookmarks.compactMap { try? URL(resolvingBookmarkData: $0, relativeTo: nil, bookmarkDataIsStale: &bool) }
    }

    private static let menuTitle = NSLocalizedString("RecentsMenuDataSource.menuTitle", comment: "Title for the Open Recents menu")
}
#endif
