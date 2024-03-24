//  Created by Geoff Pado on 2/16/22.
//  Copyright © 2022 Cocoatype, LLC. All rights reserved.

import Editing
import Purchasing
import UIKit
import VisionKit

class DocumentScanningController: NSObject, VNDocumentCameraViewControllerDelegate {
    init(delegate: DocumentScanningDelegate?) {
        self.delegate = delegate
        super.init()
    }

    @MainActor func cameraViewController() async -> UIViewController {
        if await purchased {
            let cameraViewController = VNDocumentCameraViewController()
            cameraViewController.delegate = self
            cameraViewController.overrideUserInterfaceStyle = .dark
            cameraViewController.view.tintColor = .controlTint
            return cameraViewController
        } else {
            return DocumentScannerNotPurchasedAlertController(learnMoreAction: delegate?.presentPurchaseMarketing)
        }
    }

    private var purchased: Bool {
        get async {
            return await PurchaseVerifier().hasUserPurchased
        }
    }

    func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFinishWith scan: VNDocumentCameraScan) {
        guard scan.pageCount > 0 else { return delegate?.dismissDocumentScanner() ?? () }
        let pageImage = scan.imageOfPage(at: 0)

        if scan.pageCount > 1 {
            let alert = PageCountAlertFactory.alert { [weak self] in
                self?.dismissAndEdit(pageImage)
            }
            controller.present(alert, animated: true)
        } else {
            dismissAndEdit(pageImage)
        }
    }

    func dismissAndEdit(_ image: UIImage) {
        delegate?.dismissDocumentScanner()
        delegate?.presentPhotoEditingViewController(for: image, redactions: nil, animated: true, completionHandler: nil)
    }

    private weak var delegate: DocumentScanningDelegate?
}

protocol DocumentScanningDelegate: AnyObject, PhotoEditorPresenting {
    func presentPurchaseMarketing()
    func dismissDocumentScanner()
}
