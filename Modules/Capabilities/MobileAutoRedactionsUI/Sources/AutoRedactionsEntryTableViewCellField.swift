//  Created by Geoff Pado on 4/22/24.
//  Copyright © 2024 Cocoatype, LLC. All rights reserved.

import DesignSystem
import UIKit

class AutoRedactionsEntryTableViewCellField: UITextField {
    private let fieldDelegate = Delegate()

    init() {
        super.init(frame: .zero)

        adjustsFontForContentSizeCategory = true
        autocapitalizationType = .none
        delegate = fieldDelegate
        font = .appFont(forTextStyle: .subheadline)
        attributedPlaceholder = NSAttributedString(
            string: Self.placeholder,
            attributes: [.foregroundColor: UIColor.primaryExtraLight]
        )
        returnKeyType = .done
        textColor = .white
        translatesAutoresizingMaskIntoConstraints = false

        addTarget(nil, action: #selector(AutoRedactionsListViewController.saveNewWord(_:)), for: .editingDidEnd)
    }

    @available(*, unavailable)
    required init(coder: NSCoder) {
        let className = String(describing: type(of: self))
        fatalError("\(className) does not implement init(coder:)")
    }

    private static let placeholder = Strings.AutoRedactionsEntryTableViewCellField.placeholder

    class Delegate: NSObject, UITextFieldDelegate {
        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            textField.resignFirstResponder()
            return false
        }
    }
}
