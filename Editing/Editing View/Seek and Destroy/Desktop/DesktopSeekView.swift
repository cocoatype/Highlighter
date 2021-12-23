//  Created by Geoff Pado on 12/20/21.
//  Copyright © 2021 Cocoatype, LLC. All rights reserved.

import UIKit
import ErrorHandling

class DesktopSeekView: UIView {
    init() {
        super.init(frame: .zero)

        backgroundColor = .clear
        clipsToBounds = true
        translatesAutoresizingMaskIntoConstraints = false

        layer.cornerRadius = DesktopSeekBox.Style.outer.cornerRadius

        addSubview(box)
        addSubview(innerBox)

        NSLayoutConstraint.activate([
            box.topAnchor.constraint(equalTo: topAnchor),
            box.trailingAnchor.constraint(equalTo: trailingAnchor),
            box.bottomAnchor.constraint(equalTo: bottomAnchor),
            box.leadingAnchor.constraint(equalTo: leadingAnchor),
            innerBox.topAnchor.constraint(equalTo: box.topAnchor, constant: 8),
            innerBox.centerXAnchor.constraint(equalTo: box.centerXAnchor),
            innerBox.centerYAnchor.constraint(equalTo: centerYAnchor),
            innerBox.leadingAnchor.constraint(equalTo: box.leadingAnchor, constant: 8)
        ])
    }

    override var intrinsicContentSize: CGSize { return CGSize(width: 312, height: 50) } //UIView.noIntrinsicMetric

    // MARK: Boilerplate

    private let box = DesktopSeekBox(style: .outer)
    private let innerBox = DesktopSeekTextBox()

    @available(*, unavailable)
    required init(coder: NSCoder) {
        ErrorHandling.notImplemented()
    }
}
