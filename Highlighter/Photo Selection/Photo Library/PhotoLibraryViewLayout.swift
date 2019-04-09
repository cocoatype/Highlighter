//  Created by Geoff Pado on 4/8/19.
//  Copyright © 2019 Cocoatype, LLC. All rights reserved.

import UIKit

class PhotoLibraryViewLayout: UICollectionViewFlowLayout {
    override init() {
        super.init()
    }

    override func prepare() {
        super.prepare()

        itemSize = PhotoLibraryViewLayout.itemSize(for: collectionView?.traitCollection)
    }

    // MARK: Boilerplate

    private static let smallCellSize = CGSize(width: 50.0, height: 50.0)
    private static let largeCellSize = CGSize(width: 100.0, height: 100.0)

    private static func itemSize(for traitCollection: UITraitCollection?) -> CGSize {
        let horizontalSizeClass = traitCollection?.horizontalSizeClass ?? .unspecified
        let verticalSizeClass = traitCollection?.verticalSizeClass ?? .unspecified

        if (horizontalSizeClass, verticalSizeClass) == (.regular, .regular) {
            return largeCellSize
        } else { return smallCellSize }
    }

    @available(*, unavailable)
    required init(coder: NSCoder) {
        let className = String(describing: type(of: self))
        fatalError("\(className) does not implement init(coder:)")
    }
}
