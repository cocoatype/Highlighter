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

    private static let pitch = UIColor(hexLiteral: 0x0d0d0d)
    private static let tarPit = UIColor(hexLiteral: 0x161616)
    private static let tar = UIColor(hexLiteral: 0x1b1b1b)
    private static let inkBlack = UIColor(hexLiteral: 0x232220)
    private static let rule = UIColor(hexLiteral: 0x2e2d2a)
    private static let inkBright = UIColor(hexLiteral: 0xebebeb)
    private static let ink = UIColor(hexLiteral: 0xcbcbcb)
    private static let inkDim = UIColor(hexLiteral: 0xb8b6b1)
    private static let accent = UIColor(hexLiteral: 0xf8e08e)
    private static let paper = UIColor(hexLiteral: 0xf4f1ea)
    private static let paperRule = UIColor(hexLiteral: 0xe6e1d2)
    private static let paperInk = UIColor(hexLiteral: 0x6e6a5c)

    struct Borders {
        public static let standard = UIColor.rule
        public static let accent = UIColor.accent
        public static let accentDim = UIColor.accent.withAlphaComponent(0.4)
    }

    // MARK: Legacy Colors

    static let primaryUltraLight = UIColor.ink
    static let primaryExtraLight = UIColor.inkDim
    static let primaryLight = UIColor.inkDim
    static let primary = UIColor.tar
    static let primaryDark = UIColor.pitch

    static let controlTint = UIColor(light: .primary, dark: .white)
    static let tableViewCellBackground = UIColor.inkBlack
    static let tableViewCellBackgroundHighlighted = UIColor.rule

    static let seekBoxInnerBorder = UIColor(white: 1.0, alpha: 0.22)
    static let seekBoxOuterBorder = UIColor(
        light: UIColor(white: 0.0, alpha: 0.22),
        dark: UIColor(white: 0.0, alpha: 0.8),
    )

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
