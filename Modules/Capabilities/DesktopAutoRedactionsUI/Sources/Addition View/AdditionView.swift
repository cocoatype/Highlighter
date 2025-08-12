//  Created by Geoff Pado on 8/11/25.
//  Copyright © 2025 Cocoatype, LLC. All rights reserved.

import UIKit

class AdditionView: UIView {
    private let saveButton = SaveButton()
    private let cancelButton = CancelButton()
    private let textContainer = AdditionTextContainer()
    private let separator = AdditionSeparator()

    init() {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false

        addSubview(textContainer)
        addSubview(separator)
        addSubview(saveButton)
        addSubview(cancelButton)

        NSLayoutConstraint.activate([
            textContainer.leadingAnchor.constraint(equalToSystemSpacingAfter: leadingAnchor, multiplier: 1),
            textContainer.trailingAnchor.constraint(equalToSystemSpacingAfter: trailingAnchor, multiplier: -1),
            textContainer.topAnchor.constraint(equalToSystemSpacingBelow: topAnchor, multiplier: 1),

            separator.topAnchor.constraint(equalTo: textContainer.bottomAnchor, constant: 20),
            separator.leadingAnchor.constraint(equalTo: leadingAnchor),
            separator.trailingAnchor.constraint(equalTo: trailingAnchor),

            saveButton.topAnchor.constraint(equalTo: separator.bottomAnchor, constant: 20),
            saveButton.bottomAnchor.constraint(equalToSystemSpacingBelow: bottomAnchor, multiplier: -1),
            saveButton.trailingAnchor.constraint(equalToSystemSpacingAfter: trailingAnchor, multiplier: -1),
            cancelButton.trailingAnchor.constraint(equalToSystemSpacingAfter: saveButton.leadingAnchor, multiplier: -1),
            cancelButton.centerYAnchor.constraint(equalTo: saveButton.centerYAnchor),
        ])
    }

    var text: String? { textContainer.text }

    func startTextEntry() {
        textContainer.startTextEntry()
    }

    // MARK: Boilerplate

    @available(*, unavailable)
    required init(coder: NSCoder) {
        let typeName = NSStringFromClass(type(of: self))
        fatalError("\(typeName) does not implement init(coder:)")
    }
}
