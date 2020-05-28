//  Created by Geoff Pado on 5/27/20.
//  Copyright © 2020 Cocoatype, LLC. All rights reserved.

import Editing
import UIKit

class CollectionTableViewCellLabel: UILabel {
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
