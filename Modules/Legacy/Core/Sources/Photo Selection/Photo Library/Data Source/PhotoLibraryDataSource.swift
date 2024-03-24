//  Created by Geoff Pado on 4/8/19.
//  Copyright © 2019 Cocoatype, LLC. All rights reserved.

import Combine
import ErrorHandling
import Photos
import Purchasing
import SwiftUI
import UIKit
import VisionKit

@MainActor class PhotoLibraryDataSource: NSObject, LibraryDataSource, UICollectionViewDataSource {
    let collection: Collection
    init(_ collection: Collection) {
        self.collection = collection
        self.assetsProvider = PhotoLibraryDataSourceAssetsProvider(collection: collection)
        self.changeCalculator = PhotoLibraryDataSourceChangeCalculator(collection: collection)
        self.extraItemsProvider = PhotoLibraryDataSourceExtraItemsProvider()
        super.init()
    }

    func refresh() async {
        await extraItemsProvider.refresh()
    }

    func calculateChange(in libraryView: PhotoLibraryView, from change: PHChange) {
        let result = changeCalculator.changedResult(for: change)
        assetsProvider.handleChangedResult(result)
        changeCalculator.update(libraryView, from: change)
    }

    // MARK: Data Source

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return itemsCount
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch item(at: indexPath) {
        case .asset(_):
            return assetsProvider.cell(for: collectionView, at: indexPath)
        case .documentScan:
            return extraItemsProvider.documentScannerCell(for: collectionView, at: indexPath)
        case .limitedLibrary:
            return extraItemsProvider.limitedLibraryCell(for: collectionView, at: indexPath)
        }
    }

    // MARK: Photos

    var itemsCount: Int { assetsProvider.photosCount + extraItemsProvider.extraItems.count }

    func item(at index: Int) -> PhotoLibraryItem {
        let photosCount = assetsProvider.photosCount
        guard index < photosCount else { return extraItemsProvider.item(atIndex: index - photosCount) }
        return assetsProvider.item(atIndex: index)
    }
    
    func item(at indexPath: IndexPath) -> PhotoLibraryItem {
        item(at: indexPath.item)
    }

    var lastItemIndexPath: IndexPath {
        IndexPath(row: itemsCount - 1, section: 0)
    }

    // MARK: Providers

    private let assetsProvider: PhotoLibraryDataSourceAssetsProvider
    private var extraItemsProvider: PhotoLibraryDataSourceExtraItemsProvider
    private let changeCalculator: PhotoLibraryDataSourceChangeCalculator
}
