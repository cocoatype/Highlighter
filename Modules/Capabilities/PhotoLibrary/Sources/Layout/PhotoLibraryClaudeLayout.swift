//  Created by Claude on 8/29/25.
//  Copyright © 2025 Cocoatype, LLC. All rights reserved.

import OSLog
import UIKit

class PhotoLibraryClaudeLayout: UICollectionViewFlowLayout {
    
    private var metrics: LayoutMetrics?
    private var lastBoundsWidth: CGFloat = 0
    private var previousItemsPerRow: Int = 0
    private var focalItemIndex: Int?
    private var focalItemVisualOffset: CGFloat?
    private var isResizing: Bool = false
    
    override init() {
        super.init()
        setupDefaults()
    }
    
    override func prepare() {
        os_log("🖼️ Preparing")
        super.prepare()
        
        guard let collectionView = collectionView else { return }
        
        let newMetrics = LayoutMetrics.calculate(for: collectionView.bounds.width, preferredItemsPerRow: previousItemsPerRow)
        
        // Only update if metrics have changed
        if metrics != newMetrics {
            os_log("🖼️ Updating metrics")
            metrics = newMetrics
            previousItemsPerRow = newMetrics.itemsPerRow
            applyMetrics(newMetrics)
        }
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        guard let collectionView = collectionView else { return false }
        
        let currentBounds = collectionView.bounds
        
        // Only invalidate if width changed significantly (prevents micro-adjustments)
        let widthDifference = abs(newBounds.width - lastBoundsWidth)
        let shouldInvalidate = widthDifference > 5.0  // Increased threshold to reduce noise
        
        if shouldInvalidate {
            // Only store focal item once at the start of a resize sequence
            if !isResizing {
                storeFocalItem(currentBounds: currentBounds)
                isResizing = true
                os_log("🎯 🚀 Starting resize sequence")
            }
            lastBoundsWidth = newBounds.width
        } else if isResizing {
            // Width has stabilized, end resize sequence
            isResizing = false
            clearFocalItem()
            os_log("🎯 🏁 Ending resize sequence")
        }
        
        os_log("🖼️ Should invalidate layout? (\(shouldInvalidate)) - width diff: \(widthDifference)")
        return shouldInvalidate
    }
    
    override func invalidationContext(forBoundsChange newBounds: CGRect) -> UICollectionViewLayoutInvalidationContext {
        let context = super.invalidationContext(forBoundsChange: newBounds)
        
        guard let collectionView = collectionView,
              let focalItemIndex = self.focalItemIndex,
              let focalItemVisualOffset = self.focalItemVisualOffset else {
            os_log("🎯 No focal item for bounds change")
            return context
        }
        
        let currentBounds = collectionView.bounds
        guard newBounds.width != currentBounds.width else { return context }
        
        os_log("🎯 Calculating scroll adjustment for focal item \(focalItemIndex)")
        
        // Calculate new position for focal item using new metrics
        let newMetrics = LayoutMetrics.calculate(for: newBounds.width, preferredItemsPerRow: previousItemsPerRow)
        
        // Calculate where the focal item will be in the new layout
        let row = focalItemIndex / newMetrics.itemsPerRow
        let newItemY = CGFloat(row) * (newMetrics.itemSize + newMetrics.spacing)
        
        // Calculate target scroll position to maintain visual offset
        let targetScrollY = newItemY - focalItemVisualOffset
        
        context.contentOffsetAdjustment = CGPoint(
            x: 0,
            y: targetScrollY - currentBounds.minY
        )
        
        os_log("🎯 Focal item will be at y=\(newItemY), target scroll=\(targetScrollY), adjustment=\(context.contentOffsetAdjustment.y)")
        
        // Don't clear focal item here - keep it for the entire resize sequence
        return context
    }
    
    
    private func storeFocalItem(currentBounds: CGRect) {
        guard let collectionView = collectionView else { return }
        
        // Try to find an item near the center of the visible area
        let focalPoint = CGPoint(x: currentBounds.midX, y: currentBounds.midY)
        
        if let indexPath = collectionView.indexPathForItem(at: focalPoint),
           let attributes = layoutAttributesForItem(at: indexPath) {
            self.focalItemIndex = indexPath.item
            self.focalItemVisualOffset = attributes.frame.minY - currentBounds.minY
            os_log("🎯 Stored focal item \(indexPath.item) at visual offset \(self.focalItemVisualOffset ?? 0)")
        } else {
            os_log("🎯 Could not find focal item")
            self.clearFocalItem()
        }
    }
    
    private func clearFocalItem() {
        self.focalItemIndex = nil
        self.focalItemVisualOffset = nil
    }
    
    
    override var collectionViewContentSize: CGSize {
        guard let collectionView = collectionView,
              let metrics = metrics else {
            return super.collectionViewContentSize
        }
        
        let itemCount = collectionView.numberOfItems(inSection: 0)
        let numberOfRows = metrics.numberOfRows(for: itemCount)
        
        let height = CGFloat(numberOfRows) * metrics.itemSize + 
                     CGFloat(max(0, numberOfRows - 1)) * metrics.spacing
        
        return CGSize(width: collectionView.bounds.width, height: height)
    }
    
    // MARK: Private Methods
    
    private func setupDefaults() {
        minimumInteritemSpacing = 1.0
        minimumLineSpacing = 1.0
        sectionInset = .zero
        itemSize = CGSize(width: 150, height: 150) // Default, will be overridden
    }
    
    private func applyMetrics(_ metrics: LayoutMetrics) {
        itemSize = CGSize(width: metrics.itemSize, height: metrics.itemSize)
        minimumInteritemSpacing = metrics.spacing
        minimumLineSpacing = metrics.spacing
        sectionInset = UIEdgeInsets(
            top: 0,
            left: metrics.leadingInset,
            bottom: 0,
            right: metrics.trailingInset
        )
    }
    
    
    // MARK: Boilerplate
    
    @available(*, unavailable)
    required init(coder: NSCoder) {
        let className = String(describing: type(of: self))
        fatalError("\(className) does not implement init(coder:)")
    }
}

// MARK: - Layout Metrics

struct LayoutMetrics: Equatable {
    let itemSize: CGFloat
    let spacing: CGFloat
    let itemsPerRow: Int
    let leadingInset: CGFloat
    let trailingInset: CGFloat
    
    static func calculate(for width: CGFloat, preferredItemsPerRow: Int = 0) -> LayoutMetrics {
        let spacing: CGFloat = 1.0
        let minItemWidth: CGFloat = 150.0
        let maxItemWidth: CGFloat = 300.0
        
        os_log("🔢 Calculating metrics for width: \(width), preferredItemsPerRow: \(preferredItemsPerRow)")
        
        // If we have a preference, try it first with some tolerance
        if preferredItemsPerRow > 0 {
            let totalSpacing = CGFloat(preferredItemsPerRow - 1) * spacing
            let availableWidth = width - totalSpacing
            let itemWidth = availableWidth / CGFloat(preferredItemsPerRow)
            
            // Use wider tolerance to prevent switching (140-320 instead of 150-300)
            if itemWidth >= 140.0 && itemWidth <= 320.0 {
                let result = LayoutMetrics(
                    itemSize: itemWidth,
                    spacing: spacing,
                    itemsPerRow: preferredItemsPerRow,
                    leadingInset: 0,
                    trailingInset: 0
                )
                os_log("🔢 📌 Sticking with preferred \(preferredItemsPerRow) items/row, \(itemWidth)pt each")
                return result
            }
            os_log("🔢 🚫 Preferred config doesn't work: itemWidth=\(itemWidth)")
        }
        
        // Calculate the maximum number of items that can fit with minimum width
        let maxItemsWithMinWidth = Int(floor((width + spacing) / (minItemWidth + spacing)))
        os_log("🔢 Max items with min width: \(maxItemsWithMinWidth)")
        
        // Start with this count and work backwards to find optimal size
        for itemsPerRow in stride(from: maxItemsWithMinWidth, to: 0, by: -1) {
            let totalSpacing = CGFloat(itemsPerRow - 1) * spacing
            let availableWidth = width - totalSpacing
            let itemWidth = availableWidth / CGFloat(itemsPerRow)
            
            os_log("🔢 Testing itemsPerRow=\(itemsPerRow), itemWidth=\(itemWidth)")
            
            // Check if this item width is within our constraints
            if itemWidth >= minItemWidth && itemWidth <= maxItemWidth {
                let result = LayoutMetrics(
                    itemSize: itemWidth,
                    spacing: spacing,
                    itemsPerRow: itemsPerRow,
                    leadingInset: 0,
                    trailingInset: 0
                )
                os_log("🔢 ✅ Found valid metrics: \(itemsPerRow) items/row, \(itemWidth)pt each")
                return result
            }
        }
        
        // Fallback: use minimum width and center the grid
        let itemsPerRow = Int(floor((width + spacing) / (minItemWidth + spacing)))
        let totalItemWidth = CGFloat(itemsPerRow) * minItemWidth
        let totalSpacing = CGFloat(itemsPerRow - 1) * spacing
        let usedWidth = totalItemWidth + totalSpacing
        let leftoverWidth = width - usedWidth
        let sideInset = leftoverWidth / 2.0
        
        let result = LayoutMetrics(
            itemSize: minItemWidth,
            spacing: spacing,
            itemsPerRow: max(1, itemsPerRow),
            leadingInset: sideInset,
            trailingInset: sideInset
        )
        os_log("🔢 ⚠️ Using fallback metrics: \(result.itemsPerRow) items/row, \(result.itemSize)pt each, inset: \(sideInset)")
        return result
    }
    
    func numberOfRows(for itemCount: Int) -> Int {
        return Int(ceil(Double(itemCount) / Double(itemsPerRow)))
    }
    
    func position(for itemIndex: Int) -> CGPoint {
        let row = itemIndex / itemsPerRow
        let column = itemIndex % itemsPerRow
        
        let x = leadingInset + (CGFloat(column) * (itemSize + spacing))
        let y = CGFloat(row) * (itemSize + spacing)
        
        return CGPoint(x: x, y: y)
    }
    
    static func == (lhs: LayoutMetrics, rhs: LayoutMetrics) -> Bool {
        return lhs.itemSize == rhs.itemSize &&
               lhs.spacing == rhs.spacing &&
               lhs.itemsPerRow == rhs.itemsPerRow &&
               lhs.leadingInset == rhs.leadingInset &&
               lhs.trailingInset == rhs.trailingInset
    }
}
