//  Created by Geoff Pado on 11/27/26.
//  Copyright © 2026 Cocoatype, LLC. All rights reserved.

import FactoryKit

import EditingEngine

extension Container: @retroactive AutoRegistering {
    public func autoRegister() {
        legacyIntersectionFinder.register { PhotoEditingLibraryIntersectionFinder() }
    }
}
