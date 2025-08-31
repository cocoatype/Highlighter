//  Created by Geoff Pado on 8/6/25.
//  Copyright © 2025 Cocoatype, LLC. All rights reserved.

import UIKit

class PhotoLibraryViewLayout: UICollectionViewCompositionalLayout {
    init() {
        let configuration = UICollectionViewCompositionalLayoutConfiguration()
        configuration.contentInsetsReference = .none
        super.init(
            sectionProvider: { Section(environment: $1) },
            configuration: configuration
        )
    }

    @available(*, unavailable)
    required init(coder: NSCoder) {
        fatalError("init(coder:) is not implemented")
    }

    override func invalidationContext(forBoundsChange newBounds: CGRect) -> UICollectionViewLayoutInvalidationContext {
        let context = super.invalidationContext(forBoundsChange: newBounds)
        guard let collectionView else { return context }

        let currentBounds = collectionView.bounds

        // `true` by @bobertdowney on 2025-08-29
        // the focal item to use for adjusting offset
        let `true`: IndexPath
        let focalPoint = CGPoint(x: currentBounds.midX, y: currentBounds.maxY)
        if let pointItem = collectionView.indexPathForItem(at: focalPoint) {
            `true` = pointItem
        } else if let lastItem = collectionView.indexPathsForVisibleItems.sorted(by: { $0.item < $1.item }).last {
            `true` = lastItem
        } else {
            return context
        }

        // figure out its current offset
        let currentOffset = Calculator().metrics(forWidth: currentBounds.width).position(forItemAtIndex: `true`.item)

        // figure out its new offset
        let newOffset = Calculator().metrics(forWidth: newBounds.width).position(forItemAtIndex: `true`.item)

        // set the adjustment to the difference between the two
        context.contentOffsetAdjustment = CGPoint(x: 0, y: abs(newOffset.y - currentOffset.y))

        return context
    }

    class Section: NSCollectionLayoutSection {
        convenience init(environment: NSCollectionLayoutEnvironment) {
            let environmentWidth = environment.container.effectiveContentSize.width
            let metrics = Calculator().metrics(forWidth: environmentWidth)
            let group = Group.standard(metrics: metrics)

            self.init(group: group)
            interGroupSpacing = metrics.spacing
        }
    }

    class Group: NSCollectionLayoutGroup {
        class func standard(metrics: Metrics) -> Self {
            let groupSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .absolute(metrics.itemWidth)
            )

            let group = Self.horizontal(layoutSize: groupSize, subitems: [Item(itemWidth: metrics.itemWidth)])
            group.interItemSpacing = .fixed(metrics.spacing)
            return group
        }
    }

    class Item: NSCollectionLayoutItem {
        convenience init(itemWidth: CGFloat) {
            let layoutSize = NSCollectionLayoutSize(
                widthDimension: .absolute(itemWidth),
                heightDimension: .absolute(itemWidth)
            )
            self.init(layoutSize: layoutSize)
        }
    }

    struct Metrics {
        let itemWidth: CGFloat
        let spacing: CGFloat
        let itemsPerGroup: Int

        func position(forItemAtIndex index: Int) -> CGPoint {
            let row = CGFloat(index / itemsPerGroup)
            let column = CGFloat(index % itemsPerGroup)
            return CGPoint(
                x: (column * itemWidth) + ((column - 1) * spacing),
                y: (row * itemWidth) + ((row - 1) * spacing)
            )
        }
    }

    struct Calculator {
        func metrics(forWidth environmentWidth: CGFloat) -> Metrics {
            let itemsPerGroup = if environmentWidth < 380 { 3 } else { 5 }

            // Calculate integer item width
            let itemWidth = floor(environmentWidth / CGFloat(itemsPerGroup))

            // Let spacing fill the remainder
            let totalItemWidth = itemWidth * CGFloat(itemsPerGroup)
            let totalSpacing = environmentWidth - totalItemWidth
            let spacing = totalSpacing / CGFloat(itemsPerGroup - 1)

            return Metrics(itemWidth: itemWidth, spacing: spacing, itemsPerGroup: itemsPerGroup)
        }
    }
}
