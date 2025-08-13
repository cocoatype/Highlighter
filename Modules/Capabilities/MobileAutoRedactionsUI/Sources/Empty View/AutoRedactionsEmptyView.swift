//  Created by Geoff Pado on 8/26/19.
//  Copyright © 2019 Cocoatype, LLC. All rights reserved.

import DesignSystem
import UIKit

class AutoRedactionsEmptyView: UIView {
    init() {
        let promptLabel = PromptLabel(text: AutoRedactionsEmptyView.promptLabelText)
        let promptButton = PromptButton(title: AutoRedactionsEmptyView.promptButtonTitle)
        promptButton.addTarget(nil, action: #selector(AutoRedactionsEditViewController.addNewWord), for: .touchUpInside)

        super.init(frame: .zero)

        backgroundColor = .primary

        addSubview(promptLabel)
        addSubview(promptButton)

        NSLayoutConstraint.activate([
            promptLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            promptLabel.bottomAnchor.constraint(equalTo: centerYAnchor),
            promptLabel.widthAnchor.constraint(equalToConstant: 240),
            promptButton.leadingAnchor.constraint(equalTo: promptLabel.leadingAnchor),
            promptButton.topAnchor.constraint(equalToSystemSpacingBelow: promptLabel.bottomAnchor, multiplier: 1),
        ])
    }

    // MARK: Boilerplate

    private static let promptLabelText = Strings.AutoRedactionsEmptyView.promptLabelText
    private static let promptButtonTitle = Strings.AutoRedactionsEmptyView.promptButtonTitle

    @available(*, unavailable)
    required init(coder: NSCoder) {
        let className = String(describing: type(of: self))
        fatalError("\(className) does not implement init(coder:)")
    }
}
