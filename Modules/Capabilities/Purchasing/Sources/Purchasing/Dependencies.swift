//  Created by Geoff Pado on 7/9/25.
//  Copyright © 2025 Cocoatype, LLC. All rights reserved.

import Foundation

import FactoryKit

public extension Container {
    var purchaseRepository: Factory<any PurchaseRepository> {
        Factory(self) {
            if ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] != nil {
                return PreviewRepository()
            } else if #available(iOS 16.0, *) {
                return StoreRepository()
            } else {
                // not worth handling iOS 15, they get the app for free
                return LegacyRepository()
            }
        }.singleton
    }
}
