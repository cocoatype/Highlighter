//  Created by Geoff Pado on 8/11/25.
//  Copyright © 2025 Cocoatype, LLC. All rights reserved.

import UIKit

class AdditionTextContainer: UIView {
    private let label = AdditionTextLabel()
    private let textField = AdditionTextField()
    init() {
        super.init(frame: .zero)
        backgroundColor = Self.backgroundColor
        translatesAutoresizingMaskIntoConstraints = false

        layer.cornerRadius = 8
        layer.borderColor = UIColor.separator.cgColor
        layer.borderWidth = 1

        addSubview(label)
        addSubview(textField)

        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 11),
            label.firstBaselineAnchor.constraint(equalTo: textField.firstBaselineAnchor),
            textField.leadingAnchor.constraint(equalTo: label.trailingAnchor, constant: 11),
            textField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -11),
            textField.topAnchor.constraint(equalTo: topAnchor, constant: 11),
            textField.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -11),
        ])
    }

    private static let backgroundColor = UIColor { traitCollection in
        let baseColor = if traitCollection.userInterfaceStyle == .dark { UIColor.white }
        else { UIColor.black }
        return baseColor.withAlphaComponent(0.015)
    }

    var text: String? { textField.text }

    func startTextEntry() {
        textField.becomeFirstResponder()
    }

    // MARK: Boilerplate

    @available(*, unavailable)
    required init(coder: NSCoder) {
        let typeName = NSStringFromClass(type(of: self))
        fatalError("\(typeName) does not implement init(coder:)")
    }
}
