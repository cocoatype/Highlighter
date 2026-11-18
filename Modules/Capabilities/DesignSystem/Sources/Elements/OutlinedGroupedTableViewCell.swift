//  Created by Geoff Pado on 11/16/26.
//  Copyright © 2026 Cocoatype, LLC. All rights reserved.

import UIKit

/// A table view cell for an inset grouped table that strokes the outline of its group.
open class OutlinedGroupedTableViewCell: UITableViewCell {
    open override func updateConfiguration(using state: UICellConfigurationState) {
        super.updateConfiguration(using: state)
        backgroundConfiguration = Self.configuration(in: self)
    }

    open override func layoutSubviews() {
        super.layoutSubviews()

        // the table view only clips the cells it rounds, but the outline relies on every
        // cell clipping the edges it pushes outside its bounds
        clipsToBounds = true

        // the table view doesn't update a cell's configuration when it changes the cell's
        // corners (e.g. a row is inserted above the first row), so do that ourselves
        let corners = GroupedCellCorners(self)
        if corners != lastCorners {
            lastCorners = corners
            setNeedsUpdateConfiguration()
        }
    }

    private var lastCorners: GroupedCellCorners?

    /// A background for a cell in an inset grouped list that strokes the outline of the
    /// whole group, rather than each individual cell.
    public static func configuration(in cell: UIView, isHighlighted: Bool = false) -> UIBackgroundConfiguration {
        var background = UIBackgroundConfiguration.listGroupedCell()
        background.backgroundColor = isHighlighted ? .tableViewCellBackgroundHighlighted : .tableViewCellBackground
        background.strokeColor = UIColor.Borders.standard
        background.strokeWidth = outlineWidth

        // the inset grouped layout rounds the group by clipping the first and last cells to
        // its own corner radius, so match that radius and push any unrounded edge outside the
        // cell's clipping bounds. that strokes only the outline of the group, not each cell.
        let corners = GroupedCellCorners(cell)
        background.cornerRadius = max(corners.top, corners.bottom)
        let overflow = -(background.cornerRadius + outlineWidth)
        background.backgroundInsets = NSDirectionalEdgeInsets(
            top: corners.top > 0 ? 0 : overflow,
            leading: 0,
            bottom: corners.bottom > 0 ? 0 : overflow,
            trailing: 0
        )
        return background
    }

    private static let outlineWidth = CGFloat(1)
}

private struct GroupedCellCorners: Equatable {
    let top: CGFloat
    let bottom: CGFloat

    @MainActor init(_ cell: UIView) {
        if #available(iOS 26, *) {
            top = cell.effectiveRadius(corner: [.topLeft, .topRight])
            bottom = cell.effectiveRadius(corner: [.bottomLeft, .bottomRight])
        } else {
            let layer = cell.layer
            top = layer.maskedCorners.isDisjoint(with: [.layerMinXMinYCorner, .layerMaxXMinYCorner]) ? 0 : layer.cornerRadius
            bottom = layer.maskedCorners.isDisjoint(with: [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]) ? 0 : layer.cornerRadius
        }
    }
}
