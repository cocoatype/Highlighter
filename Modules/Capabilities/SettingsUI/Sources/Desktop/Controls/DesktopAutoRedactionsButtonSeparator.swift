//  Created by Geoff Pado on 8/11/25.
//  Copyright © 2025 Cocoatype, LLC. All rights reserved.

import UIKit

class DesktopAutoRedactionsButtonSeparator: UIView {
    init() {
        super.init(frame: .zero)
        backgroundColor = .separator
        translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            widthAnchor.constraint(equalToConstant: 1),
        ])
    }

    @available(*, unavailable)
    required init(coder: NSCoder) {
        fatalError("\(String(describing: type(of: Self.self))) does not implement init(coder:)")
    }
}
