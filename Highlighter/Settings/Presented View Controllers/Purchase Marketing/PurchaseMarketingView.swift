//  Created by Geoff Pado on 8/17/19.
//  Copyright © 2019 Cocoatype, LLC. All rights reserved.

import UIKit

class PurchaseMarketingView: UIView {
    init() {
        super.init(frame: .zero)
        backgroundColor = .primary

        purchaseButton.addTarget(nil, action: #selector(SettingsNavigationController.startPurchase), for: .primaryActionTriggered)

        addSubview(label)
        addSubview(purchaseButton)

        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: topAnchor, constant: 20.0),
            label.leadingAnchor.constraint(equalTo: readableContentGuide.leadingAnchor),
            label.trailingAnchor.constraint(equalTo: readableContentGuide.trailingAnchor),
            purchaseButton.leadingAnchor.constraint(equalTo: label.leadingAnchor),
            purchaseButton.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 26.0)
        ])
    }

    // MARK: Boilerplate

    private static let marketingText = NSLocalizedString("PurchaseMarketingView.marketingText", comment: "Marketing text for the purchase marketing view")
    private static let purchaseButtonTitle = NSLocalizedString("PurchaseMarketingView.purchaseButtonTitleWithoutProduct", comment: "Title for the purchase button on the purchase marketing view")

    private let label = PurchaseMarketingViewLabel(text: PurchaseMarketingView.marketingText)
    private let purchaseButton = PromptButton(title: PurchaseMarketingView.purchaseButtonTitle)

    @available(*, unavailable)
    required init(coder: NSCoder) {
        let typeName = NSStringFromClass(type(of: self))
        fatalError("\(typeName) does not implement init(coder:)")
    }
}
