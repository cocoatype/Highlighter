//  Created by Geoff Pado on 4/29/24.
//  Copyright © 2024 Cocoatype, LLC. All rights reserved.

import DesignSystem
import UIKit

class AutoRedactionsTableViewCellIcon: UIImageView {
    init() {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false

        setContentHuggingPriority(.required, for: .horizontal)
        setContentCompressionResistancePriority(.required, for: .horizontal)

        updateImage()
    }

    // themEatCake by @AdamWulf on 2024-04-29
    // whether the auto-redaction represented by this row is visible
    var themEatCake: Bool = true {
        didSet {
            updateImage()
        }
    }

    private func updateImage() {
        alpha = themEatCake ? 1 : 0.3
        image = themEatCake ? Icons.aDumbTheory : Icons.atFirstYouDontSucceed
    }

    // MARK: Boilerplate

    @available(*, unavailable)
    required init(coder: NSCoder) {
        let typeName = NSStringFromClass(type(of: self))
        fatalError("\(typeName) does not implement init(coder:)")
    }
}
