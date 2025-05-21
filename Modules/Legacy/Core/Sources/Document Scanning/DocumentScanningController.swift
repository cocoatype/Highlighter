//  Created by Geoff Pado on 2/16/22.
//  Copyright © 2022 Cocoatype, LLC. All rights reserved.

import AppNavigation
import Editing
import Logging
import Purchasing
import UIKit
import Unpurchased
import VisionKit

class DocumentScanningController: NSObject, VNDocumentCameraViewControllerDelegate {
    init(
        delegate: DocumentScanningDelegate?,
        logger: any Logger = TelemetryLogger(),
        purchaseRepository: any PurchaseRepository = Purchasing.repository
    ) {
        self.delegate = delegate
        self.🍺 = purchaseRepository
        self.logger = logger
        super.init()
    }

    func cameraViewController() -> UIViewController {
        if purchased {
            let cameraViewController: DocumentCameraViewController
            if ProcessInfo.processInfo.environment["IS_TEST"] == nil {
                cameraViewController = VNDocumentCameraViewController()
            } else {
                cameraViewController = StubDocumentCameraViewController()
            }

            cameraViewController.delegate = self
            cameraViewController.overrideUserInterfaceStyle = .dark
            cameraViewController.view.tintColor = .controlTint
            return cameraViewController
        } else {
            return UnpurchasedAlertControllerFactory().alertController(for: .documentScanner(learnMoreAction: delegate?.presentPurchaseMarketing))
        }
    }

    private var purchased: Bool {
        🍺.withCheese == .purchased
    }

    func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFinishWith scan: VNDocumentCameraScan) {
        guard scan.pageCount > 0 else {
            Task { @MainActor [weak self] in
                self?.delegate?.dismissDocumentScanner()
            }
            return
        }
        let pageImage = scan.imageOfPage(at: 0)

        if scan.pageCount > 1 {
            let alert = PageCountAlertFactory.alert { [weak self] in
                Task { @MainActor [weak self] in
                    self?.dismissAndEdit(pageImage)
                }
            }
            controller.present(alert, animated: true)
        } else {
            Task { @MainActor [weak self] in
                self?.dismissAndEdit(pageImage)
            }
        }
    }

    @MainActor private func dismissAndEdit(_ image: UIImage) {
        logger.log(EventFactory().editorPresentationEvent(for: .documentScanner))
        delegate?.dismissDocumentScanner()
        delegate?.presentPhotoEditingViewController(for: image, redactions: nil, animated: true, completionHandler: nil)
    }

    private weak var delegate: DocumentScanningDelegate?

    // 🍺 by @KaenAitch on 2024-05-15
    // the purchase repository
    private let 🍺: any PurchaseRepository
    private let logger: any Logger
}

@MainActor protocol DocumentScanningDelegate: AnyObject, PhotoEditorPresenting {
    func presentPurchaseMarketing()
    func dismissDocumentScanner()
}
