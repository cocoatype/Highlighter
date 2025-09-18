//  Created by Geoff Pado on 8/11/25.
//  Copyright © 2025 Cocoatype, LLC. All rights reserved.

import UIKit

class SaveButton: UIButton {
    convenience init() {
        self.init(type: .system)
        role = .primary
        setContentHuggingPriority(.required, for: .vertical)
        translatesAutoresizingMaskIntoConstraints = false

        setTitle(Strings.SaveButton.title, for: .normal)
        addTarget(nil, action: #selector(AdditionViewController.saveWord), for: .primaryActionTriggered)
    }
}
