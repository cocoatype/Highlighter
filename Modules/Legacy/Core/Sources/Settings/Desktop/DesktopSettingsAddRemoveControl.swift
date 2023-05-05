//  Created by Geoff Pado on 9/27/20.
//  Copyright © 2020 Cocoatype, LLC. All rights reserved.

import ErrorHandling
import UIKit

class DesktopSettingsAddRemoveControl: UISegmentedControl {
    static let addIndex = 0
    static let removeIndex = 1

    init() {
        guard let plusImage = UIImage(systemName: "plus"), let minusImage = UIImage(systemName: "minus") else { ErrorHandler().crash("Unable to create plus and minus images") }
        super.init(items: [plusImage, minusImage])
        isMomentary = true
        translatesAutoresizingMaskIntoConstraints = false
    }

    @available(*, unavailable)
    required init(coder: NSCoder) {
        let typeName = NSStringFromClass(type(of: self))
        fatalError("\(typeName) does not implement init(coder:)")
    }
}
