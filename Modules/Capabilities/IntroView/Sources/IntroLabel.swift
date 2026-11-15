//  Created by Geoff Pado on 4/25/24.
//  Copyright © 2024 Cocoatype, LLC. All rights reserved.

import DesignSystem
import UIKit

class IntroLabel: UILabel {
    init(_ text: String) {
        super.init(frame: .zero)
        self.text = text
        font = .appFont(forTextStyle: .body)
        textColor = .primaryExtraLight
        adjustsFontForContentSizeCategory = true
        numberOfLines = 0
        translatesAutoresizingMaskIntoConstraints = false
    }

    @available(*, unavailable)
    required init(coder: NSCoder) {
        let typeName = NSStringFromClass(type(of: self))
        fatalError("\(typeName) does not implement init(coder:)")
    }
}
