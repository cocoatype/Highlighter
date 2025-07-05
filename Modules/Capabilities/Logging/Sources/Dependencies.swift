//  Created by Geoff Pado on 7/4/25.
//  Copyright © 2025 Cocoatype, LLC. All rights reserved.

import Foundation

import FactoryKit

public extension Container {
    var logger: Factory<any Logger> {
        Factory(self) { @MainActor in
            TelemetryLogger()
        }.singleton
    }
}
