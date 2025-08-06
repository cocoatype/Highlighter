//  Created by Geoff Pado on 7/15/25.
//  Copyright © 2025 Cocoatype, LLC. All rights reserved.

import AppNavigation

@MainActor public protocol DocumentScanningDelegate: AnyObject, PhotoEditorPresenting {
    func presentPurchaseMarketing()
    func dismissDocumentScanner()
}
