//  Created by Geoff Pado on 4/3/19.
//  Copyright © 2019 Cocoatype, LLC. All rights reserved.

import UIKit

public extension UIColor {
    #if targetEnvironment(macCatalyst)
    static let appBackground = UIColor.secondarySystemBackground
    #else
    static let appBackground = UIColor.primary
    #endif

    // MARK: Base Colors

    static let primaryUltraLight = UIColor(hexLiteral: 0xcbcbcb)
    static let primaryExtraLight = UIColor(hexLiteral: 0xababab)
    static let primaryLight = UIColor(hexLiteral: 0x484848)
    static let primary = UIColor(hexLiteral: 0x212121)
    static let primaryDark = UIColor(hexLiteral: 0x1b1b1b)

    static let controlTint = UIColor(light: .primary, dark: .white)
    static let tableViewCellBackground = UIColor(hexLiteral: 0x2c2c2c)
    static let tableViewCellBackgroundHighlighted = UIColor.primaryLight
    static let tableViewSeparator = UIColor(hexLiteral: 0x878787)

    static let seekBoxInnerBorder = UIColor(named: "Seek Box Inner Border")
    static let seekBoxOuterBorder = UIColor(named: "Seek Box Outer Border")

    // MARK: - Dynamic Colors
    convenience init(light: UIColor, dark: UIColor) {
        self.init { traitCollection in
            switch traitCollection.userInterfaceStyle {
            case .dark: return dark
            case .light, .unspecified: fallthrough
            @unknown default: return light
            }
        }
    }

    // MARK: - Hex

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
