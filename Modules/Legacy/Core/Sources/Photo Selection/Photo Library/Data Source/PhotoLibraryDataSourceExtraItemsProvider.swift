//  Created by Geoff Pado on 5/31/21.
//  Copyright © 2021 Cocoatype, LLC. All rights reserved.

import Defaults
import Editing
import ErrorHandling
import Purchasing
import VisionKit

class PhotoLibraryDataSourceExtraItemsProvider {
    var itemsCount: Int { extraItems.count }
    func item(atIndex index: Int) -> PhotoLibraryItem {
        extraItems[index]
    }
    
    init() {
        self.extraItems = []
    }

    // MARK: Document Scanning
    private static var documentScannerSupported: Bool {
        guard ProcessInfo.processInfo.environment.keys.contains("FORCE_DOCUMENT_SCANNER_SUPPORTED") == false else {
            return true
        }

        return VNDocumentCameraViewController.isSupported
    }

    private static var shouldShowDocumentScannerCell: Bool {
        get async {
            let hasPurchased = await PurchaseVerifier().hasUserPurchased
            return documentScannerSupported && (hideDocumentScanner == false || hasPurchased)
        }
    }

    func documentScannerCell(for collectionView: UICollectionView, at indexPath: IndexPath) -> UICollectionViewCell {
        return collectionView.dequeueReusableCell(withReuseIdentifier: DocumentScannerPhotoLibraryViewCell.identifier, for: indexPath)
    }

    // MARK: Limited Library

    private static var shouldShowLimitedLibraryCell: Bool {
        permissionsRequester.authorizationStatus() == .limited
    }

    func limitedLibraryCell(for collectionView: UICollectionView, at indexPath: IndexPath) -> UICollectionViewCell {
        #if targetEnvironment(macCatalyst)
        ErrorHandler().crash("Tried to display a limited library cell on macOS")
        #else
        return collectionView.dequeueReusableCell(withReuseIdentifier: LimitedLibraryPhotoLibraryViewCell.identifier, for: indexPath)
        #endif
    }

    // MARK: Items Cache

    private(set) var extraItems: [PhotoLibraryItem]

    private static func generateExtraItems() async -> [PhotoLibraryItem] {
        var extraItems = [PhotoLibraryItem]()

        if await shouldShowDocumentScannerCell {
            extraItems.append(.documentScan)
        }

        if shouldShowLimitedLibraryCell {
            extraItems.append(.limitedLibrary)
        }

        return extraItems
    }

    func refresh() async {
        self.extraItems = await Self.generateExtraItems()
    }

    // MARK: Boilerplate

    @Defaults.Value(key: .hideDocumentScanner) private static var hideDocumentScanner: Bool

    private static let permissionsRequester = PhotoPermissionsRequester()
}
