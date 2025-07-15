//  Created by Geoff Pado on 7/15/25.
//  Copyright © 2025 Cocoatype, LLC. All rights reserved.

import FactoryKit

public extension Container {
    var errorHandler: Factory<any ErrorHandler> {
        Factory(self) {
            DefaultHandler()
        }
    }
}
