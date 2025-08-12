//  Created by Geoff Pado on 5/31/24.
//  Copyright © 2024 Cocoatype, LLC. All rights reserved.

import FactoryKit

import Defaults
import Detections

@MainActor struct AutoRedactionsCategoryDefaultsMapper {
    @Injected(\.defaults) private var defaults

    func value(for category: Category) -> Bool {
        defaults.value(for: key(for: category))
    }

    func set(_ value: Bool, for category: Category) {
        defaults.set(value, for: key(for: category))
    }

    private func key(for category: Category) -> Key<Bool> {
        switch category {
        case .names:
            return Keys.autoRedactionsCategoryNames
        case .addresses:
            return Keys.autoRedactionsCategoryAddresses
        case .phoneNumbers:
            return Keys.autoRedactionsCategoryPhoneNumbers
        }
    }
}
