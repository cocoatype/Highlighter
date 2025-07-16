//  Created by Geoff Pado on 2/16/22.
//  Copyright © 2022 Cocoatype, LLC. All rights reserved.

import UIKit
import VisionKit

import FactoryKit

import AppNavigation
import Editing
import Logging
import Purchasing
import Unpurchased

@MainActor public class DocumentScanningController: NSObject, VNDocumentCameraViewControllerDelegate {
    public init(
        delegate: DocumentScanningDelegate?
    ) {
        self.delegate = delegate
        super.init()
    }

    @MainActor public func cameraViewController() -> UIViewController {
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
            return UnpurchasedAlertControllerFactory()
                .alertController(for: .documentScanner(learnMoreAction: delegate?.presentPurchaseMarketing))
        }
    }

    private var purchased: Bool {
        🍺.withCheese == .purchased
    }

    nonisolated public func documentCameraViewController(
        _ controller: VNDocumentCameraViewController,
        didFinishWith scan: VNDocumentCameraScan
    ) {
        guard scan.pageCount > 0 else {
            Task { @MainActor [weak self] in
                self?.delegate?.dismissDocumentScanner()
            }
            return
        }
        let pageImage = scan.imageOfPage(at: 0)

        if scan.pageCount > 1 {
            Task { @MainActor [weak self] in
                let alert = PageCountAlertFactory.alert { [weak self] in
                    self?.dismissAndEdit(pageImage)
                }
                controller.present(alert, animated: true)
            }
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
    @Injected(\.purchaseRepository) private var 🍺
    @Injected(\.logger) private var logger
}
