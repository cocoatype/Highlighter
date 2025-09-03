//  Created by Geoff Pado on 4/8/19.
//  Copyright © 2019 Cocoatype, LLC. All rights reserved.

import AlbumsData
import Combine
import ErrorHandling
import Photos
import SwiftUI
import UIKit
import VisionKit

class PhotoLibraryDataSource: NSObject, LibraryDataSource, UICollectionViewDataSource {
    let collection: PhotoCollection
    init(_ collection: PhotoCollection) {
        self.collection = collection
        self.assetsProvider = PhotoLibraryDataSourceAssetsProvider(collection: collection)
        self.changeCalculator = PhotoLibraryDataSourceChangeCalculator(collection: collection)
        super.init()
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
        return assetsProvider.cell(for: collectionView, at: indexPath)
    }

    // MARK: Photos

    var itemsCount: Int { assetsProvider.photosCount }

    var lastItemIndexPath: IndexPath {
        IndexPath(row: itemsCount - 1, section: 0)
    }

    // MARK: Providers

    private let assetsProvider: PhotoLibraryDataSourceAssetsProvider
    private let changeCalculator: PhotoLibraryDataSourceChangeCalculator
}
