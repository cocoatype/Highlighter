//  Created by Geoff Pado on 4/3/19.
//  Copyright © 2019 Cocoatype, LLC. All rights reserved.

import UIKit

public extension UIColor {
    static let primaryExtraLight = UIColor(hexLiteral: 0xababab)
    static let primaryLight = UIColor(hexLiteral: 0x484848)
    static let primary = UIColor(hexLiteral: 0x212121)
    static let primaryDark = UIColor(hexLiteral: 0x1b1b1b)

    static let controlTint = UIColor(named: "Web Tint Color")
    static let tableViewCellBackground = UIColor(hexLiteral: 0x2c2c2c)
    static let tableViewSeparator = UIColor(hexLiteral: 0x878787)

    convenience init(hexLiteral hex: Int) {
        let red = CGFloat((hex & 0xFF0000) >> 16)
        let green = CGFloat((hex & 0x00FF00) >> 8)
        let blue = CGFloat((hex & 0x0000FF) >> 0)

        self.init(red: red / 255,
                  green: green / 255,
                  blue: blue / 255,
                  alpha: 1.0)
    }
}
