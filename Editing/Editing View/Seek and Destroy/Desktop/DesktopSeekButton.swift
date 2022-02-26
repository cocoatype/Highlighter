//  Created by Geoff Pado on 2/25/22.
//  Copyright © 2022 Cocoatype, LLC. All rights reserved.

import UIKit

class DesktopSeekButton: UIButton {
    init() {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false

        addTarget(nil, action: #selector(PhotoEditingViewController.finishSeeking(_:)), for: .primaryActionTriggered)

        addSubview(box)

        titleLabel?.font = Self.font
        setTitle(Self.title, for: .normal)
        setTitleColor(.secondaryLabel, for: .normal)
        setTitleColor(.label, for: .highlighted)
        contentEdgeInsets = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)

        NSLayoutConstraint.activate([
            box.topAnchor.constraint(equalTo: topAnchor),
            box.trailingAnchor.constraint(equalTo: trailingAnchor),
            box.bottomAnchor.constraint(equalTo: bottomAnchor),
            box.leadingAnchor.constraint(equalTo: leadingAnchor)
        ])
    }

    private static let font: UIFont = {
        let baseFont = UIFont.systemFont(ofSize: 12, weight: .semibold)
        let preferredFontMetrics = UIFontMetrics(forTextStyle: .callout)
        let font = preferredFontMetrics.scaledFont(for: baseFont)

        return font
    }()

    // MARK: Boilerplate

    private static let title = NSLocalizedString("DesktopSeekButton.title", comment: "Title for the finalize button on seek and destroy")

    private let box = DesktopSeekBox(style: .inner)

    @available(*, unavailable)
    required init(coder: NSCoder) {
        let typeName = NSStringFromClass(type(of: self))
        fatalError("\(typeName) does not implement init(coder:)")
    }
}
