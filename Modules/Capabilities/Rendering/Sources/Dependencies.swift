//  Created by Geoff Pado on 6/26/25.
//  Copyright © 2025 Cocoatype, LLC. All rights reserved.

import FactoryKit

public extension Container {
    var renderer: Factory<any PhotoRenderer> {
        Factory(self) {
            DataPhotoRenderer()
        }
    }
}
