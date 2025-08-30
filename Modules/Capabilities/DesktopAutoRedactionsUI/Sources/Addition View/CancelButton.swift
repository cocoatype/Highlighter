//  Created by Geoff Pado on 8/11/25.
//  Copyright © 2025 Cocoatype, LLC. All rights reserved.

import UIKit

class CancelButton: UIButton {
    convenience init() {
        self.init(type: .system)
        role = .cancel
        setContentHuggingPriority(.required, for: .vertical)
        translatesAutoresizingMaskIntoConstraints = false

        setTitle(DesktopAutoRedactionsUIStrings.CancelButton.title, for: .normal)
        addTarget(nil, action: #selector(AdditionViewController.cancel(_:)), for: .primaryActionTriggered)
    }
}
