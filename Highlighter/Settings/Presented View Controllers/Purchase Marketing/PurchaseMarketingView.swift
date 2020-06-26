//  Created by Geoff Pado on 8/17/19.
//  Copyright © 2019 Cocoatype, LLC. All rights reserved.

import StoreKit
import UIKit

class PurchaseMarketingView: UIView {
    init(product: SKProduct?) {
        self.product = product
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

    // MARK: Purchase Button

    private lazy var purchaseButton = PromptButton(title: purchaseButtonTitle)

    private var purchaseButtonTitle: String {
        guard let price = localizedProductPrice else { return Self.purchaseButtonTitleWithoutProduct }
        return String(format: Self.purchaseButtonTitleWithProduct, price)
    }

    private var localizedProductPrice: String? {
        guard let product = product else { return nil }

        if product.priceLocale != Self.priceFormatter.locale {
            Self.priceFormatter.locale = product.priceLocale
        }

        return Self.priceFormatter.string(from: product.price)
    }

    private static let priceFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.formatterBehavior = .behavior10_4
        formatter.numberStyle = .currency
        return formatter
    }()

    // MARK: Boilerplate

    private static let autoRedactionsHeader = NSLocalizedString("PurchaseMarketingView.autoRedactionsHeader", comment: "Marketing text for the purchase marketing view")
    private static let autoRedactionsText = NSLocalizedString("PurchaseMarketingView.autoRedactionsText", comment: "Marketing text for the purchase marketing view")
    private static let documentScanningHeader = NSLocalizedString("PurchaseMarketingView.documentScanningHeader", comment: "Marketing text for the purchase marketing view")
    private static let documentScanningText = NSLocalizedString("PurchaseMarketingView.documentScanningText", comment: "Marketing text for the purchase marketing view")
    private static let purchaseButtonTitleWithProduct = NSLocalizedString("PurchaseMarketingView.purchaseButtonTitleWithProduct", comment: "Title for the purchase button on the purchase marketing view")
    private static let purchaseButtonTitleWithoutProduct = NSLocalizedString("PurchaseMarketingView.purchaseButtonTitleWithoutProduct", comment: "Title for the purchase button on the purchase marketing view")
    private static let supportDevelopmentHeader = NSLocalizedString("PurchaseMarketingView.supportDevelopmentHeader", comment: "Marketing text for the purchase marketing view")
    private static let supportDevelopmentText = NSLocalizedString("PurchaseMarketingView.supportDevelopmentText", comment: "Marketing text for the purchase marketing view")

    private let autoRedactionsHeaderLabel = PurchaseMarketingViewHeaderLabel(text: autoRedactionsHeader)
    private let autoRedactionsTextLabel = PurchaseMarketingViewTextLabel(text: autoRedactionsText)
    private let documentScanningHeaderLabel = PurchaseMarketingViewHeaderLabel(text: documentScanningHeader)
    private let documentScanningTextLabel = PurchaseMarketingViewTextLabel(text: documentScanningText)
    private let supportDevelopmentHeaderLabel = PurchaseMarketingViewHeaderLabel(text: supportDevelopmentHeader)
    private let supportDevelopmentTextLabel = PurchaseMarketingViewTextLabel(text: supportDevelopmentText)
    private let stackView = PurchaseMarketingStackView()

    private let product: SKProduct?

    @available(*, unavailable)
    required init(coder: NSCoder) {
        let typeName = NSStringFromClass(type(of: self))
        fatalError("\(typeName) does not implement init(coder:)")
    }
}
