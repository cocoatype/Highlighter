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
        let isDark = traitCollection.userInterfaceStyle == .dark
        let backgroundColor = (isDark ? UIColor.tableViewEvenRowBackgroundDark : UIColor.tableViewEvenRowBackgroundLight)
        backgroundColor.setFill()
        UIBezierPath(rect: bounds).fill()

        var rowHeightStart = CGFloat(offset.y * -1)
        let rowColor = (isDark ? UIColor.tableViewOddRowBackgroundDark : UIColor.tableViewOddRowBackgroundLight)
        rowColor.setFill()
        while rowHeightStart < bounds.height {
            let rowRect = UIBezierPath(rect: CGRect(x: bounds.minX, y: rowHeightStart, width: bounds.width, height: rowHeight))
            rowRect.fill()
            rowHeightStart += rowHeight * 2
        }
    }

    func colorForRow(at indexPath: IndexPath) -> UIColor {
        let isEven = (indexPath.row % 2) == 0
        if traitCollection.userInterfaceStyle == .dark {
            return (isEven ? .tableViewEvenRowBackgroundDark : .tableViewOddRowBackgroundDark)
        } else {
            return (isEven ? .tableViewEvenRowBackgroundLight : .tableViewOddRowBackgroundLight)
        }
    }
}

private extension UIColor {
    static let tableViewEvenRowBackgroundLight = UIColor(red: (249.0 / 255.0), green: (248.0 / 255.0), blue: (248.0 / 255.0), alpha: 1)
    static let tableViewOddRowBackgroundLight = UIColor(red: (245.0 / 255.0), green: (245.0 / 255.0), blue: (245.0 / 255.0), alpha: 1)
    static let tableViewEvenRowBackgroundDark = UIColor(red: (44.0 / 255.0), green: (44.0 / 255.0), blue: (44.0 / 255.0), alpha: 1)
    static let tableViewOddRowBackgroundDark = UIColor(red: (54.0 / 255.0), green: (54.0 / 255.0), blue: (54.0 / 255.0), alpha: 1)
}
