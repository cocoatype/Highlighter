//  Created by Geoff Pado on 4/8/19.
//  Copyright © 2019 Cocoatype, LLC. All rights reserved.

import UIKit

class PhotoLibraryView: UICollectionView {
    init() {
        let layout = PhotoLibraryViewLayout()
        super.init(frame: .zero, collectionViewLayout: layout)

        isAccessibilityElement = false

        register(AssetPhotoLibraryViewCell.self, forCellWithReuseIdentifier: AssetPhotoLibraryViewCell.identifier)
        register(DocumentScannerPhotoLibraryViewCell.self, forCellWithReuseIdentifier: DocumentScannerPhotoLibraryViewCell.identifier)

        #if !targetEnvironment(macCatalyst)
        register(LimitedLibraryPhotoLibraryViewCell.self, forCellWithReuseIdentifier: LimitedLibraryPhotoLibraryViewCell.identifier)
        #endif

        backgroundColor = .primary
    }

    // MARK: Boilerplate

    @available(*, unavailable)
    required init(coder: NSCoder) {
        let className = String(describing: type(of: self))
        fatalError("\(className) does not implement init(coder:)")
    }
}
