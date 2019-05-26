//  Created by Geoff Pado on 4/8/19.
//  Copyright © 2019 Cocoatype, LLC. All rights reserved.

import UIKit

class PhotoLibraryViewLayout: UICollectionViewFlowLayout {
    override init() {
        super.init()
    }

    override func prepare() {
        super.prepare()

        guard let collectionView = collectionView else { return }

        let sideMargins = hasSideMargins ? CGFloat(15) : CGFloat.zero
        let totalWidth = collectionView.bounds.width
        let contentWidth = totalWidth - (sideMargins * 2)
        let maxItemWidth = floor(contentWidth / CGFloat(numberOfItemsPerRow))
        let totalSpacing = contentWidth - (maxItemWidth * CGFloat(numberOfItemsPerRow))
        let maxSpacing = totalSpacing / (CGFloat(numberOfItemsPerRow) - 1)

        sectionInset = UIEdgeInsets(top: 0, left: sideMargins, bottom: 0, right: sideMargins)
        minimumInteritemSpacing = maxSpacing
        minimumLineSpacing = maxSpacing
        itemSize = CGSize(width: maxItemWidth, height: maxItemWidth)
    }

    private var hasSideMargins: Bool {
        guard let traitCollection = collectionView?.traitCollection else { return false }
        guard traitCollection.userInterfaceIdiom == .pad else { return false }
        return traitCollection.horizontalSizeClass == .regular
    }

    private var numberOfItemsPerRow: Int {
        guard let collectionView = collectionView else { return 4 }
        let horizontalSizeClass = collectionView.traitCollection.horizontalSizeClass
        let width = collectionView.bounds.width

        switch horizontalSizeClass {
        case .compact:
            return width > PhotoLibraryViewLayout.compactSplitWidth ? 6 : 4
        case .regular:
            return width > PhotoLibraryViewLayout.regularSplitWidth ? 7 : 5
        default: return 4
        }
    }

    // MARK: Boilerplate

    private static let compactSplitWidth = CGFloat(500)
    private static let regularSplitWidth = CGFloat(700)

    @available(*, unavailable)
    required init(coder: NSCoder) {
        let className = String(describing: type(of: self))
        fatalError("\(className) does not implement init(coder:)")
    }
}
