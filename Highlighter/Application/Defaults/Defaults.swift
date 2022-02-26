//  Created by Geoff Pado on 5/25/19.
//  Copyright © 2019 Cocoatype, LLC. All rights reserved.

import Foundation

public enum Defaults {
    @Value(key: .numberOfSaves) public static var numberOfSaves: Int
    @Value(key: .autoRedactionsWordList) public static var autoRedactionsWordList: [String]
    @Value(key: .recentBookmarks) public private(set) static var recentBookmarks: [Data]

    public static func addRecentBookmark(_ url: URL) {
        do {
            let newBookmarkData = try url.bookmarkData()
            let existingBookmarks = try recentBookmarks.filter { bookmark in
                var bool = false
                let bookmarkURL = try URL(resolvingBookmarkData: bookmark, bookmarkDataIsStale: &bool)
                return bookmarkURL != url
            }
            let newBookmarks = [newBookmarkData] + existingBookmarks
            let truncatedBookmarks = newBookmarks.prefix(8)
            recentBookmarks = Array(truncatedBookmarks)
        } catch {
            dump(error)
        }
    }

    public static func clearRecentBookmarks() {
        recentBookmarks = []
    }

    @Value(key: .hideDocumentScanner) public static var hideDocumentScanner: Bool
}
