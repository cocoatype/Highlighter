//  Created by Geoff Pado on 5/25/19.
//  Copyright © 2019 Cocoatype, LLC. All rights reserved.

import Foundation

public enum Defaults {
    public static var numberOfSaves: Int {
        get {
            return Defaults.userDefaults.integer(forKey: Keys.numberOfSaves)
        }

        set(newNumberOfSaves) {
            Defaults.userDefaults.set(newNumberOfSaves, forKey: Keys.numberOfSaves)
        }
    }

    public static var autoRedactionsWordList: [String] {
        get {
            guard let storedArray = Defaults.userDefaults.array(forKey: Keys.autoRedactionsWordList) else { return [] }
            return storedArray.compactMap { $0 as? String }
        }

        set(newWordList) {
            Defaults.userDefaults.set(newWordList, forKey: Keys.autoRedactionsWordList)
        }
    }

    public private(set) static var recentBookmarks: [Data] {
        get {
            guard let storedArray = Defaults.userDefaults.array(forKey: Keys.recentBookmarks) else { return [] }
            return storedArray.compactMap { $0 as? Data }
        }

        set(newRecentBookmarks) {
            Defaults.userDefaults.set(newRecentBookmarks, forKey: Keys.recentBookmarks)
        }
    }

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

    private enum Keys {
        static let numberOfSaves = "Defaults.Keys.numberOfSaves2"
        static let autoRedactionsWordList = "Defaults.Keys.autoRedactionsWordList"
        static let recentBookmarks = "Defaults.Keys.recentBookmarks"
    }

    // MARK: Boilerplate

    private static var userDefaults: UserDefaults {
        return UserDefaults.standard
    }
}
