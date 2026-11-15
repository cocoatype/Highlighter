//  Created by Geoff Pado on 4/1/19.
//  Copyright © 2019 Cocoatype, LLC. All rights reserved.

import DesignSystem
import UIKit

class IntroView: UIView {
    static let maximumContentWidth = CGFloat(240)

    init(permissionAction: @escaping (() -> Void) = {}, importAction: @escaping (() -> Void) = {}) {
        permissionLabel = IntroLabel(Strings.IntroView.permissionLabelText)
        permissionButton = IntroButton(Strings.IntroView.permissionButtonTitle, action: permissionAction)
        importLabel = IntroLabel(Strings.IntroView.importLabelText)
        importButton = IntroButton(Strings.IntroView.importButtonTitle, action: importAction)

        super.init(frame: .zero)
        backgroundColor = .primary

        stackView.addArrangedSubview(permissionLabel)
        stackView.addArrangedSubview(permissionButton)
        stackView.addArrangedSubview(importLabel)
        stackView.addArrangedSubview(importButton)
        // 3pt stack spacing + 12pt of extra padding above the import label
        stackView.setCustomSpacing(15, after: permissionButton)
        addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: safeAreaLayoutGuide.centerYAnchor),
            stackView.widthAnchor.constraint(lessThanOrEqualToConstant: Self.maximumContentWidth),
            stackView.leadingAnchor.constraint(greaterThanOrEqualTo: layoutMarginsGuide.leadingAnchor),
            stackView.topAnchor.constraint(greaterThanOrEqualTo: safeAreaLayoutGuide.topAnchor),
        ])
    }

    // MARK: Boilerplate

    let permissionLabel: IntroLabel
    let permissionButton: IntroButton
    let importLabel: IntroLabel
    let importButton: IntroButton

    let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.spacing = 3
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    @available(*, unavailable)
    required init(coder: NSCoder) {
        let typeName = NSStringFromClass(type(of: self))
        fatalError("\(typeName) does not implement init(coder:)")
    }
}
