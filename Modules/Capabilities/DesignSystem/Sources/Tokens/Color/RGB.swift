//  Copyright © 2026 Geoff Pado. All rights reserved.

import CoreGraphics

struct RGB: Hashable {
    let red: Double
    let green: Double
    let blue: Double
    let alpha: Double

    init(hex: Int) {
        self.init(
            red: Double((hex & 0xFF0000) >> 16),
            green: Double((hex & 0x00FF00) >> 8),
            blue: Double((hex & 0x0000FF) >> 0),
            alpha: 1,
        )
    }

    init?(hexString: String) {
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
}
