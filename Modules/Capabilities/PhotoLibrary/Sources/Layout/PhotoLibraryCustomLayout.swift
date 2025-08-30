//  Created by Claude on 8/30/25.
//  Copyright © 2025 Cocoatype, LLC. All rights reserved.

import OSLog
import UIKit

class PhotoLibraryCustomLayout: UICollectionViewLayout {
    
    // MARK: - Configuration
    private let spacing: CGFloat = 1.0
    private let minItemWidth: CGFloat = 150.0
    private let maxItemWidth: CGFloat = 300.0
    
    // MARK: - Layout State
    private var contentSize: CGSize = .zero
    private var itemAttributes: [IndexPath: UICollectionViewLayoutAttributes] = [:]
    private var currentMetrics: GridMetrics?
    
    // MARK: - Scroll Position Preservation
    private var focalItemIndex: Int?
    private var focalItemRelativePosition: CGFloat?
    private var pendingScrollAdjustment: CGFloat?
    
    // MARK: - Layout Lifecycle
    
    override func prepare() {
        super.prepare()
        os_log("📐 CustomLayout: Preparing")
        
        guard let collectionView = collectionView else { return }
        
        let containerWidth = collectionView.bounds.width
        let newMetrics = GridMetrics.calculate(for: containerWidth, spacing: spacing, minWidth: minItemWidth, maxWidth: maxItemWidth)
        
        let shouldRecalculate = currentMetrics != newMetrics
        
        if shouldRecalculate {
            os_log("📐 Metrics changed - recalculating layout")
            
            // Store focal item before recalculation if we don't have one
            if focalItemIndex == nil {
                storeFocalItem()
            }
            
            currentMetrics = newMetrics
            calculateLayout(metrics: newMetrics)
            
            // Apply scroll position adjustment if we have one pending
            if let adjustment = pendingScrollAdjustment {
                os_log("📐 Applying scroll adjustment directly: \(adjustment)")
                
                let currentOffset = collectionView.contentOffset
                let newOffset = CGPoint(x: currentOffset.x, y: currentOffset.y + adjustment)
                collectionView.contentOffset = newOffset

                self.pendingScrollAdjustment = nil
                clearFocalItem()
            }
        }
    }

    override func invalidationContext(forBoundsChange: CGRect) -> UICollectionViewLayoutInvalidationContext {
        return super.invalidationContext(forBoundsChange: forBoundsChange)
    }

    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        guard let collectionView = collectionView else { return false }
        
        let currentBounds = collectionView.bounds
        let widthChanged = abs(newBounds.width - currentBounds.width) > 1.0
        
        if widthChanged {
            os_log("📐 Width changed: \(currentBounds.width) → \(newBounds.width)")
            
            // Store focal item if we don't have one
            if focalItemIndex == nil {
                storeFocalItem()
            }
            
            // Calculate where our focal item should be after the resize
            if let focalIndex = focalItemIndex,
               let relativePos = focalItemRelativePosition,
               let currentMetrics = currentMetrics {
                
                let newMetrics = GridMetrics.calculate(for: newBounds.width, spacing: spacing, minWidth: minItemWidth, maxWidth: maxItemWidth)
                
                let currentRow = focalIndex / currentMetrics.itemsPerRow
                let newRow = focalIndex / newMetrics.itemsPerRow
                
                // Calculate current and new positions
                let currentItemFrame = frameForItem(at: focalIndex, metrics: currentMetrics)
                let newItemFrame = frameForItem(at: focalIndex, metrics: newMetrics)
                
                // Calculate where the focal point currently appears on screen
                let currentFocalY = currentItemFrame.minY + (currentItemFrame.height * relativePos)
                let currentScreenY = currentFocalY - currentBounds.minY
                
                // Only proceed if the screen position seems reasonable
                guard currentScreenY >= 0 && currentScreenY <= currentBounds.height * 2 else {
                    os_log("📐 Screen position unreasonable (\(currentScreenY)) - clearing focal item")
                    clearFocalItem()
                    return widthChanged
                }
                
                // Calculate where the focal point will be in the new layout
                let newFocalY = newItemFrame.minY + (newItemFrame.height * relativePos)
                
                // To keep the same screen position, we need to scroll to put the new focal point at the same screen Y
                let clampedScreenY = max(0, min(currentScreenY, currentBounds.height))
                let targetScrollY = newFocalY - clampedScreenY
                
                pendingScrollAdjustment = targetScrollY - currentBounds.minY
                
                os_log("📐 Focal item \(focalIndex): row \(currentRow)→\(newRow), focalY \(currentFocalY)→\(newFocalY), screenY=\(currentScreenY)→\(clampedScreenY), adjustment=\(self.pendingScrollAdjustment ?? 0)")
            }
        }
        
        return widthChanged
    }
    
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        os_log("📐 targetContentOffset called with proposed: \(proposedContentOffset.y), pending adjustment: \(self.pendingScrollAdjustment ?? 0)")
        
        if let adjustment = pendingScrollAdjustment {
            let adjustedOffset = CGPoint(x: proposedContentOffset.x, y: proposedContentOffset.y + adjustment)
            os_log("📐 Applying scroll adjustment: \(proposedContentOffset.y) → \(adjustedOffset.y)")
            
            // Clear both the pending adjustment and focal item - it will be recalculated fresh if needed
            self.pendingScrollAdjustment = nil
            clearFocalItem()
            
            return adjustedOffset
        }
        
        return proposedContentOffset
    }
    
    // MARK: - Layout Attributes
    
    override var collectionViewContentSize: CGSize {
        return contentSize
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return itemAttributes.values.filter { $0.frame.intersects(rect) }
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return itemAttributes[indexPath]
    }
    
    // MARK: - Private Methods
    
    private func calculateLayout(metrics: GridMetrics) {
        guard let collectionView = collectionView else { return }
        
        let itemCount = collectionView.numberOfItems(inSection: 0)
        itemAttributes.removeAll()
        
        for item in 0..<itemCount {
            let indexPath = IndexPath(item: item, section: 0)
            let frame = frameForItem(at: item, metrics: metrics)
            
            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            attributes.frame = frame
            itemAttributes[indexPath] = attributes
        }
        
        // Calculate content size
        let totalRows = Int(ceil(Double(itemCount) / Double(metrics.itemsPerRow)))
        let contentHeight = CGFloat(totalRows) * metrics.itemSize + CGFloat(max(0, totalRows - 1)) * metrics.spacing
        
        contentSize = CGSize(width: metrics.containerWidth, height: contentHeight)
        
        os_log("📐 Layout calculated: \(itemCount) items, \(totalRows) rows, content size: \(self.contentSize.width)x\(self.contentSize.height)")
    }
    
    private func frameForItem(at index: Int, metrics: GridMetrics) -> CGRect {
        let row = index / metrics.itemsPerRow
        let column = index % metrics.itemsPerRow
        
        let x = metrics.leadingInset + CGFloat(column) * (metrics.itemSize + metrics.spacing)
        let y = CGFloat(row) * (metrics.itemSize + metrics.spacing)
        
        return CGRect(x: x, y: y, width: metrics.itemSize, height: metrics.itemSize)
    }
    
    private func storeFocalItem() {
        guard let collectionView = collectionView,
              let metrics = currentMetrics else { return }
        
        let visibleRect = collectionView.bounds
        let centerPoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
        
        // Find the item at the center
        if let indexPath = indexPathForItem(at: centerPoint) {
            let itemFrame = frameForItem(at: indexPath.item, metrics: metrics)
            
            focalItemIndex = indexPath.item
            
            // Store relative position within the item (0.0 = top, 1.0 = bottom)
            let relativeY = (centerPoint.y - itemFrame.minY) / itemFrame.height
            focalItemRelativePosition = max(0, min(1, relativeY))
            
            os_log("📐 Stored focal item \(indexPath.item) at relative position \(self.focalItemRelativePosition ?? 0)")
        }
    }
    
    private func indexPathForItem(at point: CGPoint) -> IndexPath? {
        guard let metrics = currentMetrics else { return nil }
        
        // Simple hit testing - could be optimized
        let row = Int(point.y / (metrics.itemSize + metrics.spacing))
        let column = Int((point.x - metrics.leadingInset) / (metrics.itemSize + metrics.spacing))
        
        let itemIndex = row * metrics.itemsPerRow + column
        
        guard itemIndex >= 0,
              let collectionView = collectionView,
              itemIndex < collectionView.numberOfItems(inSection: 0) else {
            return nil
        }
        
        return IndexPath(item: itemIndex, section: 0)
    }
    
    private func clearFocalItem() {
        focalItemIndex = nil
        focalItemRelativePosition = nil
        os_log("📐 Cleared focal item")
    }
}

// MARK: - Grid Metrics

struct GridMetrics: Equatable {
    let containerWidth: CGFloat
    let itemSize: CGFloat
    let spacing: CGFloat
    let itemsPerRow: Int
    let leadingInset: CGFloat
    let trailingInset: CGFloat
    
    static func calculate(for width: CGFloat, spacing: CGFloat, minWidth: CGFloat, maxWidth: CGFloat) -> GridMetrics {
        os_log("🔢 Calculating grid metrics for width: \(width)")
        
        // Calculate the maximum number of items that can fit with minimum width
        let maxItemsWithMinWidth = Int(floor((width + spacing) / (minWidth + spacing)))
        
        // Try each possible number of items per row, starting with the maximum
        for itemsPerRow in stride(from: maxItemsWithMinWidth, to: 0, by: -1) {
            let totalSpacing = CGFloat(itemsPerRow - 1) * spacing
            let availableWidth = width - totalSpacing
            let itemWidth = availableWidth / CGFloat(itemsPerRow)
            
            // Check if this item width is within our constraints
            if itemWidth >= minWidth && itemWidth <= maxWidth {
                let result = GridMetrics(
                    containerWidth: width,
                    itemSize: itemWidth,
                    spacing: spacing,
                    itemsPerRow: itemsPerRow,
                    leadingInset: 0,
                    trailingInset: 0
                )
                os_log("🔢 ✅ Found optimal grid: \(itemsPerRow) items/row, \(itemWidth)pt each")
                return result
            }
        }
        
        // Fallback: use minimum width and center the grid
        let itemsPerRow = max(1, Int(floor((width + spacing) / (minWidth + spacing))))
        let totalItemWidth = CGFloat(itemsPerRow) * minWidth
        let totalSpacing = CGFloat(itemsPerRow - 1) * spacing
        let usedWidth = totalItemWidth + totalSpacing
        let leftoverWidth = width - usedWidth
        let sideInset = leftoverWidth / 2.0
        
        let result = GridMetrics(
            containerWidth: width,
            itemSize: minWidth,
            spacing: spacing,
            itemsPerRow: itemsPerRow,
            leadingInset: sideInset,
            trailingInset: sideInset
        )
        os_log("🔢 ⚠️ Using fallback grid: \(itemsPerRow) items/row, \(minWidth)pt each, inset: \(sideInset)")
        return result
    }
    
    static func == (lhs: GridMetrics, rhs: GridMetrics) -> Bool {
        return lhs.containerWidth == rhs.containerWidth &&
               lhs.itemSize == rhs.itemSize &&
               lhs.itemsPerRow == rhs.itemsPerRow &&
               lhs.leadingInset == rhs.leadingInset
    }
}
