//  Created by Geoff Pado on 7/16/25.
//  Copyright © 2025 Cocoatype, LLC. All rights reserved.

@testable import Shortcuts

@available(iOS 16, *)
extension ShortcutsRedactorError {
    var isUnpurchased: Bool {
        switch self {
        case .unpurchased: true
        case .exportFailed, .noImage: false
        }
    }

    var isNoImage: Bool {
        switch self {
        case .noImage: true
        case .exportFailed, .unpurchased: false
        }
    }
}
