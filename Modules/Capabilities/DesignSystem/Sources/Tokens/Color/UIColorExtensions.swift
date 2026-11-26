//  Copyright © 2026 Geoff Pado. All rights reserved.

#if canImport(UIKit)
import UIKit

public extension UIColor {
    #if targetEnvironment(macCatalyst)
    static let appBackground = UIColor.secondarySystemBackground
    #else
    static let appBackground = UIColor.primary
    #endif

    // MARK: Base Colors

    struct Borders {
        public static let standard = UIColor(ColorTokens.Borders.standard)
        public static let accent = UIColor(ColorTokens.Borders.accent)
        public static let accentDim = UIColor(ColorTokens.Borders.accentDim)
    }

    // MARK: Legacy Colors

    static let primaryUltraLight = UIColor(ColorTokens.primaryUltraLight)
    static let primaryExtraLight = UIColor(ColorTokens.primaryExtraLight)
    static let primaryLight = UIColor(ColorTokens.primaryLight)
    static let primary = UIColor(ColorTokens.primary)
    static let primaryDark = UIColor(ColorTokens.primaryDark)

    static let controlTint = UIColor(ColorTokens.controlTint)
    static let tableViewCellBackground = UIColor(ColorTokens.tableViewCellBackground)
    static let tableViewCellBackgroundHighlighted = UIColor(ColorTokens.tableViewCellBackgroundHighlighted)

    static let seekBoxInnerBorder = UIColor(white: 1.0, alpha: 0.22)
    static let seekBoxOuterBorder = UIColor(
        light: UIColor(white: 0.0, alpha: 0.22),
        dark: UIColor(white: 0.0, alpha: 0.8),
    )

    // MARK: - Dynamic Colors

    private convenience init(light: UIColor, dark: UIColor) {
        self.init { traitCollection in
            switch traitCollection.userInterfaceStyle {
            case .dark: return dark
            case .light, .unspecified: fallthrough
            @unknown default: return light
            }
        }
    }

    // MARK: - Hex

    private convenience init(_ rgb: RGB) {
        self.init(
            red: rgb.red,
            green: rgb.green,
            blue: rgb.blue,
            alpha: rgb.alpha,
        )
    }
}
#endif
