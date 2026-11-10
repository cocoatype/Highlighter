//  Created by Geoff Pado on 4/25/24.
//  Copyright © 2024 Cocoatype, LLC. All rights reserved.

import DesignSystem
import UIKit

class IntroButton: UIButton {
    let title: String

    init(_ title: String, action: @escaping (() -> Void)) {
        self.title = title
        super.init(frame: .zero)

        // UIButton.Configuration drops underline attributes, so this uses the classic title API.
        updateAttributedTitle()
        titleLabel?.numberOfLines = 0
        contentHorizontalAlignment = .leading
        translatesAutoresizingMaskIntoConstraints = false
        addAction(UIAction { _ in action() }, for: .primaryActionTriggered)
    }

    override var isHighlighted: Bool {
        didSet { alpha = isHighlighted ? 0.5 : 1 }
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        if traitCollection.preferredContentSizeCategory != previousTraitCollection?.preferredContentSizeCategory {
            updateAttributedTitle()
        }
    }

    private func updateAttributedTitle() {
        setAttributedTitle(NSAttributedString(string: title, attributes: [
            .font: UIFont.appFont(forTextStyle: .headline),
            .foregroundColor: UIColor.white,
            .underlineStyle: NSUnderlineStyle.single.rawValue,
        ]), for: .normal)
    }

    @available(*, unavailable)
    required init(coder: NSCoder) {
        let typeName = NSStringFromClass(type(of: self))
        fatalError("\(typeName) does not implement init(coder:)")
    }
}
