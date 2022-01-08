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

        tapRecognizer.addTarget(self, action: #selector(handleTap))
        addGestureRecognizer(tapRecognizer)
    }

    @objc public func handleTap() {
        chain(selector: #selector(PhotoEditingViewController.cancelSeeking(_:)))
    }

    // MARK: Boilerplate

    private let seekView = DesktopSeekView()
    private let tapRecognizer = UITapGestureRecognizer(target: nil, action: nil)

    @available(*, unavailable)
    required init(coder: NSCoder) {
        ErrorHandling.notImplemented()
    }
}
