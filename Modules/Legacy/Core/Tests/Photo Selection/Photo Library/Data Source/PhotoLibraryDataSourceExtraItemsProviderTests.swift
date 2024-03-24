//  Created by Geoff Pado on 3/23/24.
//  Copyright © 2024 Cocoatype, LLC. All rights reserved.

import XCTest

@testable import Core

class PhotoLibraryDataSourceExtraItemsProviderTests: XCTestCase {
    // - MARK: itemsCount
    func testExtraItemsWhenNoPurchaseDoesNotContainDocumentScan() {
        let provider = PhotoLibraryDataSourceExtraItemsProvider(
            hasPurchased: false,
            isDocumentCameraSupported: true
        )

        XCTAssertFalse(provider.extraItems.contains(where: \.isDocumentScan))
    }
}

extension PhotoLibraryItem {
    var isDocumentScan: Bool {
        switch self {
        case .documentScan: true
        case .asset, .limitedLibrary: false
        }
    }
}
