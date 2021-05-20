//  Created by Geoff Pado on 11/4/19.
//  Copyright © 2019 Cocoatype, LLC. All rights reserved.

import UIKit

class PurchaseMarketingStackView: UIStackView {
    init() {
        super.init(frame: .zero)
        alignment = .leading
        axis = .vertical
        distribution = .fill
        spacing = 26.0
        translatesAutoresizingMaskIntoConstraints = false
    }

    func addArrangedSubviews(_ views: [UIView]) {
        views.forEach(self.addArrangedSubview(_:))
    }

    // MARK: Boilerplate

    @available(*, unavailable)
    required init(coder: NSCoder) {
        let className = String(describing: type(of: self))
        fatalError("\(className) does not implement init(coder:)")
    }
}
