//  Created by Geoff Pado on 5/25/19.
//  Copyright © 2019 Cocoatype, LLC. All rights reserved.

import UIKit

class SettingsTableViewCellLabel: UILabel {
    init() {
        super.init(frame: .zero)

        adjustsFontForContentSizeCategory = true
        font = .appFont(forTextStyle: .subheadline)
        numberOfLines = 0
        textColor = .white
        translatesAutoresizingMaskIntoConstraints = false
    }

    @available(*, unavailable)
    required init(coder: NSCoder) {
        let className = String(describing: type(of: self))
        fatalError("\(className) does not implement init(coder:)")
    }
}
