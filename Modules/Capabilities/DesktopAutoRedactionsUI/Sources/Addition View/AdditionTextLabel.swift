//  Created by Geoff Pado on 8/11/25.
//  Copyright © 2025 Cocoatype, LLC. All rights reserved.

import UIKit

class AdditionTextLabel: UILabel {
    init() {
        super.init(frame: .zero)
        font = .preferredFont(forTextStyle: .body)
        text = DesktopAutoRedactionsUIStrings.AdditionTextLabel.text
        translatesAutoresizingMaskIntoConstraints = false

        setContentHuggingPriority(.required, for: .horizontal)
    }

    // MARK: Boilerplate

    @available(*, unavailable)
    required init(coder: NSCoder) {
        let typeName = NSStringFromClass(type(of: self))
        fatalError("\(typeName) does not implement init(coder:)")
    }
}
