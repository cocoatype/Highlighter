//  Created by Geoff Pado on 8/11/25.
//  Copyright © 2025 Cocoatype, LLC. All rights reserved.

import UIKit

class ListFooter: UIView {
    private let addButton = AddButton()
    private let removeButton = RemoveButton()
    private let separator = ButtonSeparator()

    init() {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false

        addSubview(addButton)
        addSubview(separator)
        addSubview(removeButton)

        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: 24),
            addButton.topAnchor.constraint(equalTo: topAnchor),
            addButton.leadingAnchor.constraint(equalTo: leadingAnchor),
            addButton.bottomAnchor.constraint(equalTo: bottomAnchor),
            separator.heightAnchor.constraint(equalToConstant: 16),
            separator.centerYAnchor.constraint(equalTo: centerYAnchor),
            separator.leadingAnchor.constraint(equalTo: addButton.trailingAnchor),
            removeButton.topAnchor.constraint(equalTo: topAnchor),
            removeButton.leadingAnchor.constraint(equalTo: separator.trailingAnchor),
            removeButton.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }

    override func draw(_ rect: CGRect) {
        super.draw(rect)

        UIColor.tableViewEvenRowBackground.setFill()
        UIBezierPath(rect: rect).fill()

        let topRect = CGRect(origin: bounds.origin, size: CGSize(width: bounds.width, height: 1))
        let intersectingRect = rect.intersection(topRect)

        UIColor.separator.setFill()
        UIBezierPath(rect: intersectingRect).fill()
    }

    @available(*, unavailable)
    required init(coder: NSCoder) {
        fatalError("\(String(describing: type(of: Self.self))) does not implement init(coder:)")
    }
}
