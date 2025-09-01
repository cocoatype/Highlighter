//  Created by Geoff Pado on 9/1/25.
//  Copyright © 2025 Cocoatype, LLC. All rights reserved.

import UIKit

import AppNavigation
import DesignSystem

public class DocumentScannerBarButtonItem: UIBarButtonItem {
    public static var standard: DocumentScannerBarButtonItem {
        let standard = DocumentScannerBarButtonItem(
            image: Icons.scanDocument,
            style: .plain,
            target: nil,
            action: #selector(DocumentScannerPresenting.presentDocumentCameraViewController)
        )
        standard.accessibilityLabel = DocumentScanningStrings.DocumentScannerBarButtonItem.accessibilityLabel
        return standard
    }

    // MARK: Boilerplate

    override init() { super.init() }

    @available(*, unavailable)
    required init(coder: NSCoder) {
        fatalError("init(coder:) is not implemented")
    }
}
