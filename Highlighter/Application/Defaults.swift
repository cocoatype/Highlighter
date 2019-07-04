//  Created by Geoff Pado on 5/25/19.
//  Copyright © 2019 Cocoatype, LLC. All rights reserved.

import Foundation

enum Defaults {
    static var numberOfSaves: Int {
        get {
            return Defaults.userDefaults.integer(forKey: Keys.numberOfSaves)
        }

        set(newNumberOfSaves) {
            Defaults.userDefaults.set(newNumberOfSaves, forKey: Keys.numberOfSaves)
        }
    }

    private enum Keys {
        static let numberOfSaves = "Defaults.Keys.numberOfSaves"
    }

    // MARK: Boilerplate

    private static var userDefaults: UserDefaults {
        return UserDefaults.standard
    }
}
