//  Created by Geoff Pado on 12/20/21.
//  Copyright © 2021 Cocoatype, LLC. All rights reserved.

import UIKit
import ErrorHandling

class DesktopSeekTextField: UITextField {
    init() {
        super.init(frame: .zero)
        borderStyle = .none
        tintColor = .white
        translatesAutoresizingMaskIntoConstraints = false

        setContentHuggingPriority(.required, for: .vertical)
    }

    override func didMoveToWindow() {
        becomeFirstResponder()
    }

    var textToRedact: String? { text }

    // MARK: Boilerplate

    @available(*, unavailable)
    required init(coder: NSCoder) {
        ErrorHandling.notImplemented()
    }
}
