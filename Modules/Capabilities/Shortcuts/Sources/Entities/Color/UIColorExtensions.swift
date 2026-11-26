//  Copyright © 2026 Geoff Pado. All rights reserved.

import UIKit

extension UIColor {
    convenience init(hexLiteral hex: Int) {
        let red = CGFloat((hex & 0xFF0000) >> 16)
        let green = CGFloat((hex & 0x00FF00) >> 8)
        let blue = CGFloat((hex & 0x0000FF) >> 0)

        self.init(red: red / 255,
                  green: green / 255,
                  blue: blue / 255,
                  alpha: 1.0)
    }

    convenience init?(hexString: String) {
        let strippedString = if hexString.hasPrefix("#") {
            String(hexString.suffix(from: hexString.index(after: hexString.startIndex)))
        } else {
            hexString
        }

        guard let int = Int(strippedString, radix: 16) else { return nil }
        self.init(hexLiteral: int)
    }

    var hexString: String {
        var red = CGFloat.zero
        var green = CGFloat.zero
        var blue = CGFloat.zero
        getRed(&red, green: &green, blue: &blue, alpha: nil)

        let redInt = Int(round(red * 255))
        let greenInt = Int(round(green * 255))
        let blueInt = Int(round(blue * 255))

        return String(format: "#%02x%02x%02x", redInt, greenInt, blueInt)
    }
}
