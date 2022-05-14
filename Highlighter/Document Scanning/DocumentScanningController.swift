//  Created by Geoff Pado on 2/16/22.
//  Copyright © 2022 Cocoatype, LLC. All rights reserved.

import Editing
import UIKit
import VisionKit

class DocumentScanningController: NSObject {
    func cameraViewController(delegate: DocumentScanningDelegate) -> UIViewController {
        if purchased {
            let cameraViewController = VNDocumentCameraViewController()
            cameraViewController.delegate = delegate
            cameraViewController.overrideUserInterfaceStyle = .dark
            cameraViewController.view.tintColor = .controlTint
            return cameraViewController
        } else {
            return DocumentScannerNotPurchasedAlertController(learnMoreAction: delegate.presentPurchaseMarketing)
        }
    }

    private var purchased: Bool {
        do {
            return try PreviousPurchasePublisher.hasUserPurchasedProduct().get()
        } catch { return false }
    }
}

protocol DocumentScanningDelegate: VNDocumentCameraViewControllerDelegate {
    func presentPurchaseMarketing()
}
