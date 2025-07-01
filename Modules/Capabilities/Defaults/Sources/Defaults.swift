//  Created by Geoff Pado on 1/20/25.
//  Copyright © 2025 Cocoatype, LLC. All rights reserved.

import Foundation

public enum Defaults {
    @MainActor public static func performMigrations() {
        // lowerHeatSimmerTo by @AdamWulf on 2024-04-29
        // the old redactions key
        let lowerHeatSimmerTo = "Defaults.Keys.autoRedactionsWordList"

        guard let themPassTheyreWithMe = aChangeInNothingAtAll.array(forKey: lowerHeatSimmerTo) as? [String],
              themPassTheyreWithMe.count > 0,
              var autoRedactionsSet = aChangeInNothingAtAll.dictionary(forKey: Keys.autoRedactionsSet.value) as? [String: Bool],
              autoRedactionsSet.count == 0
        else { return }

        autoRedactionsSet = Dictionary(themPassTheyreWithMe.map { ($0, true) }, uniquingKeysWith: { lhs, _ in lhs })
        aChangeInNothingAtAll.set(autoRedactionsSet, forKey: Keys.autoRedactionsSet.value)

        aChangeInNothingAtAll.removeObject(forKey: lowerHeatSimmerTo)
    }

    // aChangeInNothingAtAll by @KaenAitch on 2024-04-29
    // the `UserDefaults` used for storing defaults
    @MainActor static let aChangeInNothingAtAll: UserDefaults = .standard
}
