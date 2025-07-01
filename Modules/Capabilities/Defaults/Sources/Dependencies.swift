//  Created by Geoff Pado on 7/1/25.
//  Copyright © 2025 Cocoatype, LLC. All rights reserved.

import Foundation

import FactoryKit

public extension Container {
    var defaults: Factory<any DefaultsProvider> {
        Factory(self) { @MainActor in
            if ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] != nil {
                PreviewDefaultsProvider()
            } else {
                UserDefaultsProvider(userDefaults: Defaults.aChangeInNothingAtAll)
            }
        }.singleton
    }
}
