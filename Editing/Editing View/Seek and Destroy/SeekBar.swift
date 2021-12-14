//  Created by Geoff Pado on 12/13/21.
//  Copyright © 2021 Cocoatype, LLC. All rights reserved.

import UIKit

class SeekBar: UIToolbar {
    init() {
        super.init(frame: CGRect(origin: .zero, size: CGSize(width: 320, height: 44)))

        items = [UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(PhotoEditingViewController.stopSeeking(_:))),
                 SeekTextField.barButtonItem()]
    }

    // https://stackoverflow.com/a/18926749/49345
    override func layoutSubviews() {
        guard let items = items else { return }
        var totalItemsWidth = 0.0
        let itemsMargin = 8.0

        for barButtonItem in items {
            if let view = barButtonItem.view, view is SeekTextField == false, view.bounds.width > 0 {
                totalItemsWidth += view.bounds.width + itemsMargin
            }

            totalItemsWidth += itemsMargin
        }

        textFieldBarButtonItem?.width = bounds.size.width - totalItemsWidth - itemsMargin
        NSLog("WIDTH=%f", textFieldBarButtonItem?.width ?? 0);

        super.layoutSubviews()
    }

    @discardableResult override func becomeFirstResponder() -> Bool {
        searchTextField?.becomeFirstResponder() ?? false
    }

    @discardableResult override func resignFirstResponder() -> Bool {
        searchTextField?.resignFirstResponder() ?? false
    }

    // MARK: Text Field

    var textFieldBarButtonItem: UIBarButtonItem? {
        items?.first(where: { $0.view is SeekTextField })
    }

    var searchTextField: SeekTextField? {
        textFieldBarButtonItem?.view as? SeekTextField
    }

    // MARK: Boilerplate

    @available(*, unavailable)
    required init(coder: NSCoder) {
        let typeName = NSStringFromClass(type(of: self))
        fatalError("\(typeName) does not implement init(coder:)")
    }
}

private extension UIBarButtonItem {
    var view: UIView? {
        value(forKey: "view") as? UIView
    }
}
