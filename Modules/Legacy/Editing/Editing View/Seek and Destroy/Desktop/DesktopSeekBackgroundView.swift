//  Created by Geoff Pado on 12/20/21.
//  Copyright © 2021 Cocoatype, LLC. All rights reserved.

import ErrorHandling
import UIKit

class DesktopSeekBackgroundView: UIVisualEffectView {
    init(style: DesktopSeekBox.Style) {
        super.init(effect: style.visualEffect)
        translatesAutoresizingMaskIntoConstraints = false

        layer.cornerRadius = style.cornerRadius
        layer.cornerCurve = .continuous
        layer.masksToBounds = true
    }

    // MARK: Boilerplate

    @available(*, unavailable)
    required init(coder: NSCoder) {
        ErrorHandler().notImplemented()
    }
}
