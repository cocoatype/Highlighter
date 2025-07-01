//  Created by Geoff Pado on 5/16/24.
//  Copyright © 2024 Cocoatype, LLC. All rights reserved.

import PurchasingDoubles
import VisionKit
import XCTest

@testable import Core

@MainActor
class DocumentScanningControllerTests: XCTestCase {
    func testCameraViewControllerIsReturnedIfPurchased() {
        let repository = SpyRepository(withCheese: .purchased)
        let scanningController = DocumentScanningController(delegate: nil, purchaseRepository: repository)
        let cameraViewController = scanningController.cameraViewController()

        XCTAssert(cameraViewController is DocumentCameraViewController)
    }

    func testCameraViewControllerReturnsAlertIfNotPurchased() {
        let repository = SpyRepository(withCheese: .unavailable)
        let scanningController = DocumentScanningController(delegate: nil, purchaseRepository: repository)
        let cameraViewController = scanningController.cameraViewController()

        XCTAssert(cameraViewController is UIAlertController)
    }
}
