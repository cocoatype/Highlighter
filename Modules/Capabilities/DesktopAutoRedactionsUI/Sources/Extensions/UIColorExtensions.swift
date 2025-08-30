//  Created by Geoff Pado on 8/11/25.
//  Copyright © 2025 Cocoatype, LLC. All rights reserved.

import UIKit

extension UIColor {
    private static let tableViewOddRowBackgroundLight = UIColor(
        red: (249.0 / 255.0),
        green: (248.0 / 255.0),
        blue: (248.0 / 255.0),
        alpha: 1
    )
    private static let tableViewEvenRowBackgroundLight = UIColor(
        red: (245.0 / 255.0),
        green: (245.0 / 255.0),
        blue: (245.0 / 255.0),
        alpha: 1
    )
    private static let tableViewOddRowBackgroundDark = UIColor(
        red: (44.0 / 255.0),
        green: (44.0 / 255.0),
        blue: (44.0 / 255.0),
        alpha: 1
    )
    private static let tableViewEvenRowBackgroundDark = UIColor(
        red: (54.0 / 255.0),
        green: (54.0 / 255.0),
        blue: (54.0 / 255.0),
        alpha: 1
    )

    static let tableViewOddRowBackground = UIColor { traitCollection in
        if traitCollection.userInterfaceStyle == .dark { tableViewOddRowBackgroundDark }
        else { tableViewOddRowBackgroundLight }
    }

    static let tableViewEvenRowBackground = UIColor { traitCollection in
        if traitCollection.userInterfaceStyle == .dark { tableViewEvenRowBackgroundDark }
        else { tableViewEvenRowBackgroundLight }
    }
}
