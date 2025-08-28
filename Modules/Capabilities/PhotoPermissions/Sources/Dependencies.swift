//  Created by Geoff Pado on 8/28/25.
//  Copyright © 2025 Cocoatype, LLC. All rights reserved.

import Foundation

import FactoryKit

public extension Container {
    var photoPermissionsRequester: Factory<any PhotoPermissionsRequester> {
        Factory(self) { @MainActor in
            PhotoLibraryPermissionsRequester()
        }
    }
}

