//  Created by Geoff Pado on 6/24/24.
//  Copyright © 2024 Cocoatype, LLC. All rights reserved.

import UIKit

class TabletSeekSearchBar: UISearchBar, UISearchTextFieldDelegate {
    init() {
        super.init(frame: .zero)
        searchTextField.delegate = self
        returnKeyType = .done
        translatesAutoresizingMaskIntoConstraints = false

        searchTextField.addTarget(nil, action: #selector((any PhotoEditingResponderActions).seekBarDidChangeText(_:)), for: .editingChanged)
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        chain(selector: #selector((any PhotoEditingResponderActions).finishSeeking(_:)))
        return false
    }

    // MARK: Boilerplate

    @available(*, unavailable)
    required init(coder: NSCoder) {
        let typeName = NSStringFromClass(type(of: self))
        fatalError("\(typeName) does not implement init(coder:)")
    }
}
