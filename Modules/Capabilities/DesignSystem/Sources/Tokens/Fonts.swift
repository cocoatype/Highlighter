//  Created by Geoff Pado on 4/3/19.
//  Copyright © 2019 Cocoatype, LLC. All rights reserved.

import ErrorHandling
import UIKit

public extension UIFont {
    class func appFont(forTextStyle textStyle: UIFont.TextStyle) -> UIFont {
        let fontMetrics = UIFontMetrics(forTextStyle: textStyle)
        let fontMethod: ((UIFont.TextStyle) -> UIFont)
        switch textStyle {
        case .headline, .title1, .title2, .title3, .largeTitle:
            fontMethod = boldFont(for:)
        default:
            fontMethod = regularFont(for:)
        }

        let standardFont = fontMethod(textStyle)
        return fontMetrics.scaledFont(for: standardFont)
    }

    // MARK: Font Styles

    class var navigationBarLargeTitleFont: UIFont {
        return boldFont(for: .largeTitle)
    }

    class var navigationBarTitleFont: UIFont {
        return boldFont(for: .headline)
    }

    class var navigationBarButtonFont: UIFont {
        return regularFont(for: .subheadline)
    }

    // MARK: Boilerplate

    private static func boldFont(for textStyle: UIFont.TextStyle) -> UIFont {
        return standardFont(family: DesignSystemFontFamily.Aleo.bold, for: textStyle)
    }

    private static func regularFont(for textStyle: UIFont.TextStyle) -> UIFont {
        return standardFont(family: DesignSystemFontFamily.Aleo.regular, for: textStyle)
    }

    private static func standardFont(family: DesignSystemFontConvertible, for textStyle: UIFont.TextStyle) -> UIFont {
        family.font(size: standardFontSize(for: textStyle))
    }

    private static func standardFontSize(for textStyle: UIFont.TextStyle) -> CGFloat {
        #if targetEnvironment(macCatalyst)
        return macStandardFontSize(for: textStyle)
        #else
        return mobileStandardFontSize(for: textStyle)
        #endif
    }

    private static func macStandardFontSize(for textStyle: UIFont.TextStyle) -> CGFloat {
        switch textStyle {
        case .largeTitle: return 26.0
        case .title1: return 22.0
        case .title2: return 17.0
        case .title3: return 15.0
        case .headline: return 13.0
        case .body: return 13.0
        case .callout: return 12.0
        case .subheadline: return 11.0
        case .footnote: return 10.0
        case .caption1: return 10.0
        case .caption2: return 10.0
        default: return macStandardFontSize(for: .body)
        }
    }

    private static func mobileStandardFontSize(for textStyle: UIFont.TextStyle) -> CGFloat {
        switch textStyle {
        case .largeTitle: return 34.0
        case .title1: return 24.0
        case .title2: return 22.0
        case .title3: return 20.0
        case .headline: return 17.0
        case .body: return 17.0
        case .callout: return 16.0
        case .subheadline: return 15.0
        case .footnote: return 13.0
        case .caption1: return 12.0
        case .caption2: return 11.0
        default: return mobileStandardFontSize(for: .body)
        }
    }
}
