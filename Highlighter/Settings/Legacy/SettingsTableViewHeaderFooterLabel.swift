//  Created by Geoff Pado on 8/13/19.
//  Copyright © 2019 Cocoatype, LLC. All rights reserved.

import UIKit

class SettingsTableViewHeaderFooterLabel: UILabel {
    init() {
        super.init(frame: .zero)
        font = .appFont(forTextStyle: .footnote)
        textColor = .primaryExtraLight
        translatesAutoresizingMaskIntoConstraints = false
    }

    // MARK: Boilerplate

    @available(*, unavailable)
    required init(coder: NSCoder) {
        let className = String(describing: type(of: self))
        fatalError("\(className) does not implement init(coder:)")
    }

}
