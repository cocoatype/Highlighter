//  Created by Geoff Pado on 12/20/21.
//  Copyright © 2021 Cocoatype, LLC. All rights reserved.

import UIKit
import ErrorHandling

class DesktopSeekTextField: UITextField, UITextFieldDelegate {
    init() {
        super.init(frame: .zero)
        borderStyle = .none
        delegate = self
        tintColor = .white
        translatesAutoresizingMaskIntoConstraints = false

        setContentHuggingPriority(.required, for: .vertical)

        addTarget(nil, action: #selector(PhotoEditingViewController.seekBarDidChangeText(_:)), for: .editingChanged)
    }

    override func didMoveToWindow() {
        becomeFirstResponder()
    }

    var textToRedact: String? { text }

    // MARK: Key Commands

    override var keyCommands: [UIKeyCommand]? {
        let escapeCommand = UIKeyCommand(action: #selector(PhotoEditingViewController.cancelSeeking(_:)), input: UIKeyCommand.inputEscape)
        return (super.keyCommands ?? []) + [escapeCommand]
    }

    // MARK: Delegate

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        chain(selector: #selector(PhotoEditingViewController.finishSeeking(_:)))
        return false
    }

    // MARK: Boilerplate

    @available(*, unavailable)
    required init(coder: NSCoder) {
        ErrorHandler().notImplemented()
    }
}
