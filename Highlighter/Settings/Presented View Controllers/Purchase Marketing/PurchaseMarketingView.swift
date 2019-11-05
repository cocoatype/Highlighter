//  Created by Geoff Pado on 8/17/19.
//  Copyright © 2019 Cocoatype, LLC. All rights reserved.

import UIKit

class PurchaseMarketingView: UIView {
    init() {
        super.init(frame: .zero)
        backgroundColor = .primary

        purchaseButton.addTarget(nil, action: #selector(SettingsNavigationController.startPurchase), for: .primaryActionTriggered)

        addSubview(stackView)
        stackView.addArrangedSubviews([
            autoRedactionsHeaderLabel,
            autoRedactionsTextLabel,
            documentScanningHeaderLabel,
            documentScanningTextLabel,
            supportDevelopmentHeaderLabel,
            supportDevelopmentTextLabel,
            purchaseButton
        ])
        stackView.setCustomSpacing(4.0, after: autoRedactionsHeaderLabel)
        stackView.setCustomSpacing(4.0, after: documentScanningHeaderLabel)
        stackView.setCustomSpacing(4.0, after: supportDevelopmentHeaderLabel)

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: 20.0),
            stackView.leadingAnchor.constraint(equalTo: readableContentGuide.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: readableContentGuide.trailingAnchor)
        ])
    }

    // MARK: Boilerplate

    private static let autoRedactionsHeader = NSLocalizedString("PurchaseMarketingView.autoRedactionsHeader", comment: "Marketing text for the purchase marketing view")
    private static let autoRedactionsText = NSLocalizedString("PurchaseMarketingView.autoRedactionsText", comment: "Marketing text for the purchase marketing view")
    private static let documentScanningHeader = NSLocalizedString("PurchaseMarketingView.documentScanningHeader", comment: "Marketing text for the purchase marketing view")
    private static let documentScanningText = NSLocalizedString("PurchaseMarketingView.documentScanningText", comment: "Marketing text for the purchase marketing view")
    private static let supportDevelopmentHeader = NSLocalizedString("PurchaseMarketingView.supportDevelopmentHeader", comment: "Marketing text for the purchase marketing view")
    private static let supportDevelopmentText = NSLocalizedString("PurchaseMarketingView.supportDevelopmentText", comment: "Marketing text for the purchase marketing view")

    private static let purchaseButtonTitle = NSLocalizedString("PurchaseMarketingView.purchaseButtonTitleWithoutProduct", comment: "Title for the purchase button on the purchase marketing view")

    private let autoRedactionsHeaderLabel = PurchaseMarketingViewHeaderLabel(text: autoRedactionsHeader)
    private let autoRedactionsTextLabel = PurchaseMarketingViewTextLabel(text: autoRedactionsText)
    private let documentScanningHeaderLabel = PurchaseMarketingViewHeaderLabel(text: documentScanningHeader)
    private let documentScanningTextLabel = PurchaseMarketingViewTextLabel(text: documentScanningText)
    private let supportDevelopmentHeaderLabel = PurchaseMarketingViewHeaderLabel(text: supportDevelopmentHeader)
    private let supportDevelopmentTextLabel = PurchaseMarketingViewTextLabel(text: supportDevelopmentText)
    private let purchaseButton = PromptButton(title: PurchaseMarketingView.purchaseButtonTitle)
    private let stackView = PurchaseMarketingStackView()

    @available(*, unavailable)
    required init(coder: NSCoder) {
        let typeName = NSStringFromClass(type(of: self))
        fatalError("\(typeName) does not implement init(coder:)")
    }
}
