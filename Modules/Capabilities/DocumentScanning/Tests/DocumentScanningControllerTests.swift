//  Created by Geoff Pado on 5/16/24.
//  Copyright © 2024 Cocoatype, LLC. All rights reserved.

import VisionKit
import Testing

import FactoryKit
import FactoryTesting

import PurchasingDoubles

@testable import DocumentScanning

@MainActor @Suite(.container)
struct DocumentScanningControllerTests {
    @Test func cameraViewControllerIsReturnedIfPurchased() {
        Container.shared.purchaseRepository.register {
            SpyRepository(withCheese: .purchased)
        }
        let scanningController = DocumentScanningController(delegate: nil)
        let cameraViewController = scanningController.cameraViewController()

        #expect(cameraViewController is DocumentCameraViewController)
    }

    @Test func cameraViewControllerReturnsAlertIfNotPurchased() {
        Container.shared.purchaseRepository.register {
            SpyRepository(withCheese: .unavailable)
        }
        let scanningController = DocumentScanningController(delegate: nil)
        let cameraViewController = scanningController.cameraViewController()

        #expect(cameraViewController is UIAlertController)
    }
}
