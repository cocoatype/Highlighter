//  Created by Geoff Pado on 4/1/19.
//  Copyright © 2019 Cocoatype, LLC. All rights reserved.

import UIKit

class PromptLabel: UILabel {
    init(text string: String) {
        super.init(frame: .zero)

        adjustsFontForContentSizeCategory = true
        font = .appFont(forTextStyle: .body)
        numberOfLines = 0
        text = string
        textColor = .primaryExtraLight
        translatesAutoresizingMaskIntoConstraints = false
    }

    @available(*, unavailable)
    required init(coder: NSCoder) {
        let className = String(describing: type(of: self))
        fatalError("\(className) does not implement init(coder:)")
    }
}
