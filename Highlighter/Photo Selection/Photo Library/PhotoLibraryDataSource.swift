//  Created by Geoff Pado on 4/8/19.
//  Copyright © 2019 Cocoatype, LLC. All rights reserved.

import Photos
import UIKit

class PhotoLibraryDataSource: NSObject, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let fetchOptions = PHFetchOptions()
        let allPhotos = PHAsset.fetchAssets(with: fetchOptions)
        return allPhotos.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return collectionView.dequeueReusableCell(withReuseIdentifier: PhotoLibraryViewCell.identifier, for: indexPath)
    }
}
