//  Created by Geoff Pado on 9/1/25.
//  Copyright © 2025 Cocoatype, LLC. All rights reserved.

import UIKit
import VisionKit

import FactoryKit

import BarBuilder
import Defaults
import DocumentScanning
import MobileSettingsUI
import PhotoPermissions
import Purchasing

@MainActor
struct PhotoLibraryBarButtonsProvider {
    init() {
        self.init(
            isDocumentScannerSupported: VNDocumentCameraViewController.isSupported,
            permissionsRequester: PhotoLibraryPermissionsRequester()
        )
    }

    private let isDocumentScannerSupported: Bool
    private let permissionsRequester: any PhotoPermissionsRequester
    init(
        isDocumentScannerSupported: Bool,
        permissionsRequester: any PhotoPermissionsRequester
    ) {
        self.permissionsRequester = permissionsRequester
        self.isDocumentScannerSupported = isDocumentScannerSupported
    }

    @BarBuilder public var trailingNavigationItems: [UIBarButtonItem] {
        if shouldShowDocumentScannerCell {
            DocumentScannerBarButtonItem.standard
        }

        if shouldShowLimitedLibraryCell {
            LimitedLibraryBarButtonItem.standard
        }

        if shouldShowDocumentScannerCell || shouldShowLimitedLibraryCell {
            UIBarButtonItem.fixedSpace(0)
        }

        SettingsBarButtonItem.standard
    }

    // MARK: Helpers

    @Injected(\.defaults) private var defaults
    @Injected(\.purchaseRepository) private var purchaseRepository

    private var shouldShowDocumentScannerCell: Bool {
        let hideDocumentScanner = defaults.value(for: Keys.hideDocumentScanner)
        let hasPurchased = purchaseRepository.withCheese == .purchased
        return isDocumentScannerSupported && (hideDocumentScanner == false || hasPurchased)
    }

    private var shouldShowLimitedLibraryCell: Bool {
        permissionsRequester.authorizationStatus() == .limited
    }
}
