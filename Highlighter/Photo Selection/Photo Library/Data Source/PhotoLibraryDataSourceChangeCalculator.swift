//  Created by Geoff Pado on 5/31/21.
//  Copyright © 2021 Cocoatype, LLC. All rights reserved.

import Photos

class PhotoLibraryDataSourceChangeCalculator: NSObject {
    init(collection: Collection) {
        self.fetchResult = {
            guard let collection = collection as? AssetCollection else { return PHFetchResult() }
            return collection.assets
        }()
    }

    private func details(for change: PHChange) -> PHFetchResultChangeDetails<PHAsset>? {
        return change.changeDetails(for: fetchResult)
    }

    func changedResult(for change: PHChange) -> PHFetchResult<PHAsset> {
        guard let changeDetails = details(for: change) else { return fetchResult }
        return changeDetails.fetchResultAfterChanges
    }

    func update(_ libraryView: PhotoLibraryView, from change: PHChange) {
        guard let changeDetails = details(for: change) else { return }

        guard changeDetails.hasIncrementalChanges else {
            return libraryView.reloadData()
        }

        libraryView.performBatchUpdates({ [unowned libraryView, changeDetails] in
            if let removed = changeDetails.removedIndexes {
                libraryView.deleteItems(at: removed.map { IndexPath(item: $0, section:0) })
            }
            if let inserted = changeDetails.insertedIndexes {
                libraryView.insertItems(at: inserted.map { IndexPath(item: $0, section:0) })
            }
            if let changed = changeDetails.changedIndexes {
                libraryView.reloadItems(at: changed.map { IndexPath(item: $0, section:0) })
            }

            changeDetails.enumerateMoves { fromIndex, toIndex in
                libraryView.moveItem(at: IndexPath(item: fromIndex, section: 0),
                                     to: IndexPath(item: toIndex, section: 0))
            }
        }, completion: nil)
    }

    private let fetchResult: PHFetchResult<PHAsset>
}
