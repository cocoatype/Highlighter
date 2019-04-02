//  Created by Geoff Pado on 4/1/19.
//  Copyright © 2019 Cocoatype, LLC. All rights reserved.

import UIKit

class IntroView: UIView {
    init() {
        let promptLabel = PromptLabel(text: IntroView.promptLabelText)
        let promptButton = PromptButton(title: IntroView.promptButtonTitle)
        promptButton.addTarget(nil, action: #selector(IntroViewController.requestPermission), for: .touchUpInside)

        super.init(frame: .zero)

        backgroundColor = .white

        addSubview(promptLabel)
        addSubview(promptButton)

        NSLayoutConstraint.activate([
            promptLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            promptLabel.bottomAnchor.constraint(equalTo: centerYAnchor),
            promptLabel.widthAnchor.constraint(equalToConstant: 240),
            promptButton.leadingAnchor.constraint(equalTo: promptLabel.leadingAnchor),
            promptButton.topAnchor.constraint(equalToSystemSpacingBelow: promptLabel.bottomAnchor, multiplier: 1)
        ])
    }

    // MARK: Boilerplate

    private static let promptLabelText = NSLocalizedString("IntroView.promptLabelText", comment: "Text for the permissions prompt on the intro view")
    private static let promptButtonTitle = NSLocalizedString("IntroView.promptButtonTitle", comment: "Buttton title for the permissions prompt on the intro view")

    @available(*, unavailable)
    required init(coder: NSCoder) {
        let className = String(describing: type(of: self))
        fatalError("\(className) does not implement init(coder:)")
    }
}
