//  Created by Geoff Pado on 2/18/22.
//  Copyright © 2022 Cocoatype, LLC. All rights reserved.

import Editing
import UIKit

class DocumentScannerNotPurchasedAlertController: UIAlertController {
    convenience init(feedback: String) {
        let title = NSLocalizedString("DocumentScannerNotPurchasedAlertController.title", comment: "Title for the document scanner not purchased alert")
        let message = NSLocalizedString("DocumentScannerNotPurchasedAlertController.message", comment: "Message for the document scanner not purchased alert")
        self.init(title: title, message: message, preferredStyle: .alert)

        addAction(
            UIAlertAction(
                title: NSLocalizedString("DocumentScannerNotPurchasedAlertController.learnMoreButton", comment: ""),
                style: .default,
                handler: { action in
                    NSLog("learn more")
                }))

        addAction(
            UIAlertAction(
                title: NSLocalizedString("DocumentScannerNotPurchasedAlertController.hideButton", comment: ""),
                style: .default,
                handler: { [weak self] action in
                    self?.hideDocumentScanner = true
                }))

        addAction(
            UIAlertAction(
                title: NSLocalizedString("DocumentScannerNotPurchasedAlertController.dismissButton", comment: ""),
                style: .cancel,
                handler: { _ in }))
    }

    @Defaults.Value(key: .hideDocumentScanner) private var hideDocumentScanner: Bool
}
