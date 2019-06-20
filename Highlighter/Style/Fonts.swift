//  Created by Geoff Pado on 4/3/19.
//  Copyright © 2019 Cocoatype, LLC. All rights reserved.

import UIKit

extension UIFont {
    class func appFont(forTextStyle textStyle: UIFont.TextStyle) -> UIFont {
        let fontMetrics = UIFontMetrics(forTextStyle: textStyle)
        let fontMethod: ((UIFont.TextStyle) -> UIFont)
        if textStyle == .headline {
            fontMethod = boldFont(for:)
        } else {
            fontMethod = regularFont(for:)
        }

        let standardFont = fontMethod(textStyle)
        return fontMetrics.scaledFont(for: standardFont)
    }

    class var navigationBarTitleFont: UIFont {
        return boldFont(for: .headline)
    }

    class var navigationBarButtonFont: UIFont {
        return regularFont(for: .subheadline)
    }

    // MARK: Boilerplate

    private static let boldFontName = "Aleo-Bold"
    private static let regularFontName = "Aleo-Regular"

    private static func boldFont(for textStyle: UIFont.TextStyle) -> UIFont {
        return standardFont(named: UIFont.boldFontName, for: textStyle)
    }

    private static func regularFont(for textStyle: UIFont.TextStyle) -> UIFont {
        return standardFont(named: UIFont.regularFontName, for: textStyle)
    }

    private static func standardFont(named name: String, for textStyle: UIFont.TextStyle) -> UIFont {
        let size = standardFontSize(for: textStyle)
        guard let appFont = UIFont(name: name, size: size) else {
            fatalError("Couldn't get regular font")
        }

        return appFont

    }

    private static func standardFontSize(for textStyle: UIFont.TextStyle) -> CGFloat {
        switch textStyle {
        case .largeTitle: return 34.0
        case .title1: return 28.0
        case .title2: return 22.0
        case .title3: return 20.0
        case .headline: return 17.0
        case .body: return 17.0
        case .callout: return 16.0
        case .subheadline: return 15.0
        case .footnote: return 13.0
        case .caption1: return 12.0
        case .caption2: return 11.0
        default: return 17.0
        }
    }
}
