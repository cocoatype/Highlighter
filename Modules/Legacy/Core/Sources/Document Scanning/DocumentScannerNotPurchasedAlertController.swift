//  Created by Geoff Pado on 2/18/22.
//  Copyright © 2022 Cocoatype, LLC. All rights reserved.

import Defaults
import Editing
import UIKit

class DocumentScannerNotPurchasedAlertController: UIAlertController {
    convenience init(learnMoreAction: (() -> Void)?) {
        let title = NSLocalizedString("DocumentScannerNotPurchasedAlertController.title", comment: "Title for the document scanner not purchased alert")
        let message = NSLocalizedString("DocumentScannerNotPurchasedAlertController.message", comment: "Message for the document scanner not purchased alert")
        self.init(title: title, message: message, preferredStyle: .alert)

        if let learnMoreAction = learnMoreAction {
            addAction(
                UIAlertAction(
                    title: NSLocalizedString("DocumentScannerNotPurchasedAlertController.learnMoreButton", comment: ""),
                    style: .default,
                    handler: { _ in
                        learnMoreAction()
                    }))
        }

        addAction(
            UIAlertAction(
                title: NSLocalizedString("DocumentScannerNotPurchasedAlertController.hideButton", comment: ""),
                style: .default,
                handler: { [weak self] _ in
                    self?.hideDocumentScanner = true
                }))

        addAction(
            UIAlertAction(
                title: NSLocalizedString("DocumentScannerNotPurchasedAlertController.dismissButton", comment: ""),
                style: .cancel,
                handler: { _ in }))
    }

    private var latestParent: UIViewController?
    override func didMove(toParent parent: UIViewController?) {
        guard let parent = parent else { return }
        latestParent = parent
    }

    @Defaults.Value(key: .hideDocumentScanner) private var hideDocumentScanner: Bool
}
