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

    private enum Keys {
        static let numberOfSaves = "Defaults.Keys.numberOfSaves"
        static let autoRedactionsWordList = "Defaults.Keys.autoRedactionsWordList"
    }

    // MARK: Boilerplate

    private static var userDefaults: UserDefaults {
        return UserDefaults.standard
    }
}
