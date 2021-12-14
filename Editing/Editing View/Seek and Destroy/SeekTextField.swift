//  Created by Geoff Pado on 12/13/21.
//  Copyright © 2021 Cocoatype, LLC. All rights reserved.

import UIKit

class SeekTextField: UISearchTextField, UISearchTextFieldDelegate {
    static func barButtonItem() -> UIBarButtonItem {
        return UIBarButtonItem(customView: SeekTextField())
    }

    init() {
        super.init(frame: .zero)
        self.delegate = self

        addTarget(nil, action: #selector(PhotoEditingViewController.seekBarDidChangeText(_:)), for: .editingChanged)

        translatesAutoresizingMaskIntoConstraints = false
        returnKeyType = .done
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        chain(selector: #selector(PhotoEditingViewController.finishSeeking(_:)))
        return false
    }

    @available(*, unavailable)
    required init(coder: NSCoder) {
        let typeName = NSStringFromClass(type(of: self))
        fatalError("\(typeName) does not implement init(coder:)")
    }
}
