//  Created by Geoff Pado on 2/13/21.
//  Copyright © 2021 Cocoatype, LLC. All rights reserved.

import UIKit

import FactoryKit

import Defaults
import Editing
import ErrorHandling

#if targetEnvironment(macCatalyst)
@MainActor class RecentsMenuDataSource: NSObject {
    static func addRecentItem(_ url: URL, defaults: any DefaultsProvider) {
        do {
            let recentBookmarks = defaults.value(for: Keys.recentBookmarks) ?? []
            let newBookmarkData = try url.bookmarkData()
            let existingBookmarks = try recentBookmarks.filter { bookmark in
                var bool = false
                let bookmarkURL = try URL(resolvingBookmarkData: bookmark, bookmarkDataIsStale: &bool)
                return bookmarkURL != url
            }
            let newBookmarks = [newBookmarkData] + existingBookmarks
            let truncatedBookmarks = newBookmarks.prefix(8)
            defaults.set(Array(truncatedBookmarks), for: Keys.recentBookmarks)
        } catch {
            Container.shared.errorHandler()
                .log(error, module: "Core", type: "RecentsMenuDataSource")
        }

        UIMenuSystem.main.setNeedsRebuild()
    }

    static func clearRecentItems(defaults: any DefaultsProvider) {
        defaults.set([], for: Keys.recentBookmarks)
        UIMenuSystem.main.setNeedsRebuild()
    }

    var recentsMenu: UIMenu {
        UIMenu(
            title: Strings.RecentsMenuDataSource.menuTitle,
            identifier: nil,
            children: menuItems + [clearMenu]
        )
    }

    private var menuItems: [UIMenuElement] {
        recentItemsURLs.map { url in
            UICommand(title: url.lastPathComponent, image: icon(for: url), action: #selector(AppDelegate.openRecentFile(_:)), propertyList: url.path)
        }
    }

    private let clearMenu = UIMenu(
        options: .displayInline,
        children: [
            UICommand(
                title: Strings.RecentsMenuDataSource.clearMenuItemTitle,
                action: #selector(AppDelegate.clearRecents)
            ),
        ]
    )

    private func icon(for url: URL) -> UIImage? {
        let cgImage = FileIconFetcher().icon(for: url).takeUnretainedValue()
        return UIImage(cgImage: cgImage, scale: UIScreen.main.scale, orientation: .up)
    }

    private var recentItemsURLs: [URL] {
        var bool = false
        @Injected(\.defaults) var defaults
        let recentBookmarks = defaults.value(for: Keys.recentBookmarks) ?? []
        return recentBookmarks
            .compactMap { try? URL(resolvingBookmarkData: $0, relativeTo: nil, bookmarkDataIsStale: &bool) }
    }
}
#endif
