//  Created by Geoff Pado on 12/20/21.
//  Copyright © 2021 Cocoatype, LLC. All rights reserved.

import UIKit
import ErrorHandling

class DesktopSeekContainerView: UIView {
    init() {
        super.init(frame: .zero)

        backgroundColor = .clear
        isOpaque = false
        preservesSuperviewLayoutMargins = false

        layoutMargins = .zero

        addSubview(seekView)

        NSLayoutConstraint.activate([
            seekView.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor, constant: 8),
            seekView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8)
        ])
    }

    // MARK: Boilerplate

    private let seekView = DesktopSeekView()

    @available(*, unavailable)
    required init(coder: NSCoder) {
        ErrorHandling.notImplemented()
    }
}
