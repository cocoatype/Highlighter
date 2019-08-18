//  Created by Geoff Pado on 8/17/19.
//  Copyright © 2019 Cocoatype, LLC. All rights reserved.

import UIKit

class PurchaseMarketingView: UIView {
    init() {
        super.init(frame: .zero)
        backgroundColor = .primary

        addSubview(label)
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: topAnchor, constant: 20.0),
            label.leadingAnchor.constraint(equalTo: readableContentGuide.leadingAnchor),
            label.trailingAnchor.constraint(equalTo: readableContentGuide.trailingAnchor)
        ])
    }

    // MARK: Boilerplate

    private static let marketingText = NSLocalizedString("PurchaseMarketingView.marketingText", comment: "Marketing text for the purchase marketing view")

    private let label = PurchaseMarketingViewLabel(text: PurchaseMarketingView.marketingText)

    @available(*, unavailable)
    required init(coder: NSCoder) {
        let typeName = NSStringFromClass(type(of: self))
        fatalError("\(typeName) does not implement init(coder:)")
    }
}
