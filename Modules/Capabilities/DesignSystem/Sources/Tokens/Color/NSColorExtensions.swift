//  Copyright © 2026 Geoff Pado. All rights reserved.

#if canImport(AppKit) && !targetEnvironment(macCatalyst)
import AppKit

public extension NSColor {
    static let appBackground = NSColor.windowBackgroundColor

    // MARK: Base Colors

    struct Borders {
        public static let standard = NSColor(ColorTokens.Borders.standard)
        public static let accent = NSColor(ColorTokens.Borders.accent)
        public static let accentDim = NSColor(ColorTokens.Borders.accentDim)
    }

    // MARK: Legacy Colors

    static let primaryUltraLight = NSColor(ColorTokens.primaryUltraLight)
    static let primaryExtraLight = NSColor(ColorTokens.primaryExtraLight)
    static let primaryLight = NSColor(ColorTokens.primaryLight)
    static let primary = NSColor(ColorTokens.primary)
    static let primaryDark = NSColor(ColorTokens.primaryDark)

    static let controlTint = NSColor(ColorTokens.controlTint)
    static let tableViewCellBackground = NSColor(ColorTokens.tableViewCellBackground)
    static let tableViewCellBackgroundHighlighted = NSColor(ColorTokens.tableViewCellBackgroundHighlighted)

    static let seekBoxInnerBorder = NSColor(white: 1.0, alpha: 0.22)
    static let seekBoxOuterBorder = NSColor(
        light: NSColor(white: 0.0, alpha: 0.22),
        dark: NSColor(white: 0.0, alpha: 0.8),
    )

    // MARK: - Dynamic Colors

    private convenience init(light: NSColor, dark: NSColor) {
        self.init(name: nil) { appearance in
            switch appearance.bestMatch(from: [.aqua, .darkAqua]) {
            case .darkAqua: dark
            default: light
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
