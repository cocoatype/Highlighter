//  Copyright © 2026 Geoff Pado. All rights reserved.

import CoreGraphics

#if canImport(UIKit)
import UIKit
#elseif canImport(AppKit)
import AppKit
#endif

public struct RGB: Hashable, Sendable {
    public let red: Double
    public let green: Double
    public let blue: Double
    public let alpha: Double

    public init(hex: Int) {
        self.init(
            red: Double((hex & 0xFF0000) >> 16) / 255,
            green: Double((hex & 0x00FF00) >> 8) / 255,
            blue: Double((hex & 0x0000FF) >> 0) / 255,
            alpha: 1,
        )
    }

    public init?(hexString: String) {
        let strippedString = if hexString.hasPrefix("#") {
            String(hexString.suffix(from: hexString.index(after: hexString.startIndex)))
        } else {
            hexString
        }

        guard let int = Int(strippedString, radix: 16) else { return nil }
        self.init(hex: int)
    }

    private init(
        red: Double,
        green: Double,
        blue: Double,
        alpha: Double,
    ) {
        self.red = red
        self.green = green
        self.blue = blue
        self.alpha = alpha
    }

    func withAlphaComponent(_ newAlpha: Double) -> RGB {
        RGB(red: red, green: green, blue: blue, alpha: newAlpha)
    }

    var hexString: String {
        let redInt = Int(round(red * 255))
        let greenInt = Int(round(green * 255))
        let blueInt = Int(round(blue * 255))

        return String(format: "#%02x%02x%02x", redInt, greenInt, blueInt)
    }

    #if canImport(UIKit)
    public init(color: UIColor) {
        var red = CGFloat.zero
        var green = CGFloat.zero
        var blue = CGFloat.zero
        var alpha = CGFloat.zero
        color.getRed(&red, green: &green, blue: &blue, alpha: &alpha)

        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
    #elseif canImport(AppKit)
    #endif
}
