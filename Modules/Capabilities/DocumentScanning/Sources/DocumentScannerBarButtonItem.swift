//  Created by Geoff Pado on 9/1/25.
//  Copyright © 2025 Cocoatype, LLC. All rights reserved.

import UIKit

import FactoryKit

import AppNavigation
import DesignSystem
import Logging

public class DocumentScannerBarButtonItem: UIBarButtonItem {
    public static var standard: DocumentScannerBarButtonItem {
        let standard = DocumentScannerBarButtonItem(
            image: Icons.scanDocument,
            style: .plain,
            target: self,
            action: #selector(presentDocumentScanner(_:))
        )
        standard.accessibilityLabel = DocumentScanningStrings.DocumentScannerBarButtonItem.accessibilityLabel
        return standard
    }

    @objc static func presentDocumentScanner(_ sender: Any) {
        let logger = Container.shared.logger()
        logger.log(EventFactory().scannerPresentationEvent(for: .library))
        UIApplication.shared
            .sendAction(
                #selector(DocumentScannerPresenting.presentDocumentCameraViewController),
                to: nil,
                from: sender,
                for: nil
            )
    }

    // MARK: Boilerplate

    override init() { super.init() }

    @available(*, unavailable)
    required init(coder: NSCoder) {
        fatalError("init(coder:) is not implemented")
    }
}
