//  Created by Geoff Pado on 9/1/25.
//  Copyright © 2025 Cocoatype, LLC. All rights reserved.

import UIKit

import AppNavigation
import DesignSystem

public class LimitedLibraryBarButtonItem: UIBarButtonItem {
    public static var standard: LimitedLibraryBarButtonItem {
        let standard = LimitedLibraryBarButtonItem(
            image: Icons.limitedLibrary,
            style: .plain,
            target: nil,
            action: #selector(LimitedLibraryPresenting.presentLimitedLibrary)
        )
        standard.accessibilityLabel = PhotoLibraryStrings.DocumentScannerPhotoLibraryViewCell.defaultAccessibilityLabel
        return standard
    }

    // MARK: Boilerplate

    override init() { super.init() }

    @available(*, unavailable)
    required init(coder: NSCoder) {
        fatalError("init(coder:) is not implemented")
    }
}
