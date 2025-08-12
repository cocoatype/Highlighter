//  Created by Geoff Pado on 8/11/25.
//  Copyright © 2025 Cocoatype, LLC. All rights reserved.

import UIKit

class DesktopAutoRedactionsListHeader: UIView {
    private let label = DesktopAutoRedactionsListHeaderLabel()
    init() {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false

        addSubview(label)

        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: 28),
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            label.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
    }

    override func draw(_ rect: CGRect) {
        super.draw(rect)

        UIColor.tableViewEvenRowBackground.setFill()
        UIBezierPath(rect: rect).fill()

        let bottomRect = CGRect(
            origin: CGPoint(x: bounds.origin.x, y: bounds.maxY - 1),
            size: CGSize(width: bounds.width, height: 1)
        )
        let intersectingRect = rect.intersection(bottomRect)

        UIColor.separator.setFill()
        UIBezierPath(rect: intersectingRect).fill()
    }

    @available(*, unavailable)
    required init(coder: NSCoder) {
        fatalError("\(String(describing: type(of: Self.self))) does not implement init(coder:)")
    }
}
