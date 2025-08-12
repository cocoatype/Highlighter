//  Created by Geoff Pado on 9/27/20.
//  Copyright © 2020 Cocoatype, LLC. All rights reserved.

import UIKit

class AlternatingRowTableViewBackgroundView: UIView {
    var rowHeight = CGFloat(24)
    var offset = CGPoint.zero {
        didSet {
            setNeedsDisplay()
        }
    }

    override func draw(_ rect: CGRect) {
        let backgroundColor = UIColor.tableViewEvenRowBackground
        backgroundColor.setFill()
        UIBezierPath(rect: bounds).fill()

        var rowHeightStart = CGFloat(offset.y * -1)
        let rowColor = UIColor.tableViewOddRowBackground
        rowColor.setFill()
        while rowHeightStart < bounds.height {
            let rowRect = UIBezierPath(rect: CGRect(x: bounds.minX, y: rowHeightStart, width: bounds.width, height: rowHeight))
            rowRect.fill()
            rowHeightStart += rowHeight * 2
        }
    }

    func colorForRow(at indexPath: IndexPath) -> UIColor {
        return if (indexPath.row % 2) == 0 {
            .tableViewEvenRowBackground
        } else { .tableViewOddRowBackground }
    }
}
