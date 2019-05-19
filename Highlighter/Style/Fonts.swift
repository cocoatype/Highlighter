//  Created by Geoff Pado on 4/3/19.
//  Copyright © 2019 Cocoatype, LLC. All rights reserved.

import UIKit

extension UIFont {
    class func appFont(forTextStyle textStyle: UIFont.TextStyle) -> UIFont {
        let fontMetrics = UIFontMetrics(forTextStyle: textStyle)
        guard textStyle != .headline else { return fontMetrics.scaledFont(for: boldFont) }

        return fontMetrics.scaledFont(for: regularFont)
    }

    class var navigationBarTitleFont: UIFont {
        return boldFont
    }

    class var navigationBarButtonFont: UIFont {
        return regularFont.withSize(15.0)
    }

    // MARK: Boilerplate

    private static let boldFontName = "Aleo-Bold"
    private static let regularFontName = "Aleo-Regular"

    private static var boldFont: UIFont {
        guard let appFont = UIFont(name: UIFont.boldFontName, size: 17.0) else {
            fatalError("Couldn't get bold font")
        }

        return appFont
    }

    private static var regularFont: UIFont {
        guard let appFont = UIFont(name: UIFont.regularFontName, size: 17.0) else {
            fatalError("Couldn't get regular font")
        }

        return appFont
    }
}
