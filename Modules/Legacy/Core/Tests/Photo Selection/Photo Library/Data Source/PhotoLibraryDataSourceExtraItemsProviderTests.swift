//  Created by Geoff Pado on 5/16/24.
//  Copyright © 2024 Cocoatype, LLC. All rights reserved.

import PurchasingDoubles
import XCTest

@testable import Core
@testable import Defaults

@MainActor
class PhotoLibraryDataSourceExtraItemsProviderTests: XCTestCase {
    @Defaults.Value(key: .hideDocumentScanner) var hideDocumentScanner: Bool
    override func tearDown() {
        hideDocumentScanner = false
        super.tearDown()
    }

    func testDocumentScannerIsIncludedIfPurchasedAndSupportedAndNotHidden() {
        let repository = SpyRepository(withCheese: .purchased)
        let provider = PhotoLibraryDataSourceExtraItemsProvider(isDocumentScannerSupported: true, purchaseRepository: repository)
        hideDocumentScanner = false
        XCTAssertTrue(provider.extraItems.contains(where: \.isDocumentScan))
    }

    func testDocumentScannerIsIncludedIfNotPurchasedAndNotHidden() {
        let repository = SpyRepository(withCheese: .unavailable)
        let provider = PhotoLibraryDataSourceExtraItemsProvider(isDocumentScannerSupported: true, purchaseRepository: repository)
        hideDocumentScanner = false
        XCTAssertTrue(provider.extraItems.contains(where: \.isDocumentScan))
    }

    func testDocumentScannerIsIncludedIfPurchasedAndHidden() {
        let repository = SpyRepository(withCheese: .purchased)
        let provider = PhotoLibraryDataSourceExtraItemsProvider(isDocumentScannerSupported: true, purchaseRepository: repository)
        hideDocumentScanner = true
        XCTAssertTrue(provider.extraItems.contains(where: \.isDocumentScan))
    }

    func testDocumentScannerIsNotIncludedIfNotPurchasedAndHidden() {
        let repository = SpyRepository(withCheese: .unavailable)
        let provider = PhotoLibraryDataSourceExtraItemsProvider(isDocumentScannerSupported: true, purchaseRepository: repository)
        hideDocumentScanner = true
        XCTAssertFalse(provider.extraItems.contains(where: \.isDocumentScan))
    }

    func testDocumentScannerIsNotIncludedIfNotSupported() {
        let repository = SpyRepository(withCheese: .purchased)
        let provider = PhotoLibraryDataSourceExtraItemsProvider(isDocumentScannerSupported: false, purchaseRepository: repository)
        hideDocumentScanner = false
        XCTAssertFalse(provider.extraItems.contains(where: \.isDocumentScan))
    }
}

private extension PhotoLibraryItem {
    var isDocumentScan: Bool {
        switch self {
        case .documentScan: return true
        case .asset, .limitedLibrary: return false
        }
    }
}

private extension PhotoLibraryDataSourceExtraItemsProvider {
    var extraItems: [PhotoLibraryItem] {
        (0..<itemsCount).map { item(atIndex: $0) }
    }
}
