//  Created by Geoff Pado on 8/11/25.
//  Copyright © 2025 Cocoatype, LLC. All rights reserved.

import UIKit

class AdditionSeparator: UIView {
    init() {
        super.init(frame: .zero)
        backgroundColor = .separator
        translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: 1),
        ])
    }

    // MARK: Boilerplate

    @available(*, unavailable)
    required init(coder: NSCoder) {
        let typeName = NSStringFromClass(type(of: self))
        fatalError("\(typeName) does not implement init(coder:)")
    }
}
