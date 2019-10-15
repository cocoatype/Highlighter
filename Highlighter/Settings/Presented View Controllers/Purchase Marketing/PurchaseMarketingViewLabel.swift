//  Created by Geoff Pado on 8/17/19.
//  Copyright © 2019 Cocoatype, LLC. All rights reserved.

import BonMot
import UIKit

class PurchaseMarketingViewLabel: UILabel {
    init(text string: String) {
        super.init(frame: .zero)

        attributedText = string.styled(with: PurchaseMarketingViewLabel.textStyle)
        numberOfLines = 0
        translatesAutoresizingMaskIntoConstraints = false
    }

    override var text: String? {
        get {
            return attributedText?.string
        }

        set(newText) {
            attributedText = newText?.styled(with: PurchaseMarketingViewLabel.textStyle)
        }
    }

    // MARK: String Styling

    private static let headerStyle = StringStyle(
        .font(.appFont(forTextStyle: .title2)),
        .color(.white),
        .lineHeightMultiple(1.0),
        .paragraphSpacingAfter(4.0),
        .adapt(.body)
    )

    private static let textStyle = StringStyle(
        .font(.appFont(forTextStyle: .subheadline)),
        .color(.primaryExtraLight),
        .lineHeightMultiple(1.2),
        .paragraphSpacingAfter(26.0),
        .adapt(.body),
        .xmlRules([
            .style("header", headerStyle)
        ])
    )

    // MARK: Boilerplate

    @available(*, unavailable)
    required init(coder: NSCoder) {
        let typeName = NSStringFromClass(type(of: self))
        fatalError("\(typeName) does not implement init(coder:)")
    }
}
