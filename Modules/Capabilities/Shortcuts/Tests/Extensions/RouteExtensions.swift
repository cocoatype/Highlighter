//  Created by Geoff Pado on 7/16/25.
//  Copyright © 2025 Cocoatype, LLC. All rights reserved.

import AppNavigation

extension Route {
    var isDocumentScanner: Bool {
        switch self {
        #if !targetEnvironment(macCatalyst)
        case .documentScanner: true
        #endif
        case .editor: false
        }
    }

    var isEditor: Bool {
        switch self {
        case .editor: true
        #if !targetEnvironment(macCatalyst)
        case .documentScanner: false
        #endif
        }
    }
}
