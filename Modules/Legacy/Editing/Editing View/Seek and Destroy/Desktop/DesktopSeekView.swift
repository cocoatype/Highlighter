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
        addSubview(textBox)
        addSubview(button)

        NSLayoutConstraint.activate([
            box.topAnchor.constraint(equalTo: topAnchor),
            box.trailingAnchor.constraint(equalTo: trailingAnchor),
            box.bottomAnchor.constraint(equalTo: bottomAnchor),
            box.leadingAnchor.constraint(equalTo: leadingAnchor),
            textBox.topAnchor.constraint(equalTo: box.topAnchor, constant: 8),
            textBox.centerYAnchor.constraint(equalTo: centerYAnchor),
            textBox.leadingAnchor.constraint(equalTo: box.leadingAnchor, constant: 8),
            button.topAnchor.constraint(equalTo: textBox.topAnchor),
            button.trailingAnchor.constraint(equalTo: box.trailingAnchor, constant: -8),
            button.bottomAnchor.constraint(equalTo: textBox.bottomAnchor),
            button.leadingAnchor.constraint(equalTo: textBox.trailingAnchor, constant: 8)
        ])
    }

    override var intrinsicContentSize: CGSize { return CGSize(width: 312, height: 50) } //UIView.noIntrinsicMetric

    // MARK: Boilerplate

    private let box = DesktopSeekBox(style: .outer)
    private let textBox = DesktopSeekTextBox()
    private let button = DesktopSeekButton()

    @available(*, unavailable)
    required init(coder: NSCoder) {
        ErrorHandler().notImplemented()
    }
}
