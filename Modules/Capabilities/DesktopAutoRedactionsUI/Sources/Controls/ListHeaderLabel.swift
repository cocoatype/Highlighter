//  Created by Geoff Pado on 8/11/25.
//  Copyright © 2025 Cocoatype, LLC. All rights reserved.

import UIKit

class ListHeaderLabel: UILabel {
    init() {
        super.init(frame: .zero)

        font = Self.labelFont
        text = DesktopAutoRedactionsUIStrings.DesktopSettingsView.wordListLabel
        translatesAutoresizingMaskIntoConstraints = false
    }

    private static var labelFont: UIFont {
        let baseFont = UIFont.preferredFont(forTextStyle: .subheadline)
        let baseDescriptor = baseFont.fontDescriptor
        guard let boldDescriptor = baseDescriptor.withSymbolicTraits(.traitBold) else {
            return baseFont
        }

        return UIFont(descriptor: boldDescriptor, size: baseFont.pointSize)
    }

    @available(*, unavailable)
    required init(coder: NSCoder) {
        fatalError("\(String(describing: type(of: Self.self))) does not implement init(coder:)")
    }
}
