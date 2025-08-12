//  Created by Geoff Pado on 8/11/25.
//  Copyright © 2025 Cocoatype, LLC. All rights reserved.

import UIKit

class AdditionTextField: UITextField {
    private let textFieldDelegate = Delegate()

    init() {
        super.init(frame: .zero)
        delegate = textFieldDelegate
        textAlignment = .right
        translatesAutoresizingMaskIntoConstraints = false
    }

    // MARK: Boilerplate

    @available(*, unavailable)
    required init(coder: NSCoder) {
        let typeName = NSStringFromClass(type(of: self))
        fatalError("\(typeName) does not implement init(coder:)")
    }

    class Delegate: NSObject, UITextFieldDelegate {
        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            UIApplication.shared.sendAction(#selector(AdditionViewController.saveWord(_:)), to: nil, from: textField, for: nil)
        }
    }
}
