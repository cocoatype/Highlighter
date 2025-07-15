//  Created by Geoff Pado on 12/20/21.
//  Copyright © 2021 Cocoatype, LLC. All rights reserved.

import UIKit

import FactoryKit

import ErrorHandling

class DesktopSeekBoxLabel: UILabel {
    init() {
        super.init(frame: .zero)
        font = Self.font
        translatesAutoresizingMaskIntoConstraints = false

        setContentHuggingPriority(.required, for: .vertical)
    }

    private static let font: UIFont = {
        let baseFont = UIFont.systemFont(ofSize: 12, weight: .semibold)
        let preferredFontMetrics = UIFontMetrics(forTextStyle: .callout)
        let font = preferredFontMetrics.scaledFont(for: baseFont)

        return font
    }()

    // MARK: Boilerplate

    @available(*, unavailable)
    required init(coder: NSCoder) {
        Container.shared.errorHandler().notImplemented()
    }
}
