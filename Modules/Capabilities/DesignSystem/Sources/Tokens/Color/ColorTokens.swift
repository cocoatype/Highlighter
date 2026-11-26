//  Created by Geoff Pado on 4/3/19.
//  Copyright © 2019 Cocoatype, LLC. All rights reserved.

enum ColorTokens {
    private static let pitch = RGB(hex: 0x0d0d0d)
    private static let tarPit = RGB(hex: 0x161616)
    private static let tar = RGB(hex: 0x1b1b1b)
    private static let inkBlack = RGB(hex: 0x232220)
    private static let rule = RGB(hex: 0x2e2d2a)
    private static let inkBright = RGB(hex: 0xebebeb)
    private static let ink = RGB(hex: 0xcbcbcb)
    private static let inkDim = RGB(hex: 0xb8b6b1)
    private static let accent = RGB(hex: 0xf8e08e)
    private static let paper = RGB(hex: 0xf4f1ea)
    private static let paperRule = RGB(hex: 0xe6e1d2)
    private static let paperInk = RGB(hex: 0x6e6a5c)
    private static let white = RGB(hex: 0xffffff)

    struct Borders {
        static let standard = ColorTokens.rule
        static let accent = ColorTokens.accent
        static let accentDim = ColorTokens.accent.withAlphaComponent(0.4)
    }

    // MARK: Legacy Colors

    static let primaryUltraLight = ColorTokens.ink
    static let primaryExtraLight = ColorTokens.inkDim
    static let primaryLight = ColorTokens.inkDim
    static let primary = ColorTokens.tar
    static let primaryDark = ColorTokens.pitch

    static let controlTint = ColorTokens.white
    static let tableViewCellBackground = ColorTokens.inkBlack
    static let tableViewCellBackgroundHighlighted = ColorTokens.rule
}
