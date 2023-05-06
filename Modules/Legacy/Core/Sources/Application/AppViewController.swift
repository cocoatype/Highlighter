//  Created by Geoff Pado on 3/31/19.
//  Copyright © 2019 Cocoatype, LLC. All rights reserved.

import AppRatings
import Editing
import ErrorHandling
import Photos
import UIKit
import VisionKit
import SwiftUI

class AppViewController: UIViewController, PhotoEditorPresenting, DocumentScanningDelegate, DocumentScannerPresenting, SettingsPresenting {
    init(permissionsRequester: PhotoPermissionsRequester = PhotoPermissionsRequester()) {
        self.permissionsRequester = permissionsRequester
        super.init(nibName: nil, bundle: nil)

        view.isOpaque = false
        view.backgroundColor = .clear
        overrideUserInterfaceStyle = .dark
        embed(preferredViewController)
    }

    @objc func showPhotoLibrary() {
        transition(to: preferredViewController)
    }

    private let permissionsRequester: PhotoPermissionsRequester
    private var preferredViewController: UIViewController {
        switch permissionsRequester.authorizationStatus() {
        case .authorized, .limited: return LibrarySplitViewController()
        default: return IntroViewController()
        }
    }

    // do not move; controls initial system limited photo picker
    override func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)? = nil) {
        if viewControllerToPresent is UIImagePickerController {
            viewControllerToPresent.overrideUserInterfaceStyle = .dark
        }
        super.present(viewControllerToPresent, animated: flag, completion: completion)
    }

    private var photoEditingViewController: PhotoEditingViewController? { ((presentedViewController as? NavigationController)?.viewControllers.first as? PhotoEditingViewController) }
    var stateRestorationActivity: NSUserActivity? { photoEditingViewController?.userActivity }

    // MARK: Photo Editing View Controller

    func presentPhotoEditingViewController(for asset: PHAsset, redactions: [Redaction]? = nil, animated: Bool = true) {
        present(PhotoEditingNavigationController(asset: asset, redactions: redactions), animated: animated)
    }

    func presentPhotoEditingViewController(for image: UIImage, redactions: [Redaction]? = nil, animated: Bool = true, completionHandler: ((UIImage) -> Void)? = nil) {
        present(PhotoEditingNavigationController(image: image, redactions: redactions, completionHandler: completionHandler), animated: animated)
    }

    // MARK: Document Scanner

    private lazy var documentScanningController = DocumentScanningController(delegate: self)

    @objc func presentDocumentCameraViewController() {
        present(documentScanningController.cameraViewController(), animated: true)
    }

    func dismissDocumentScanner() {
        guard presentedViewController is VNDocumentCameraViewController else { return }
        dismiss(animated: true)
    }

    // MARK: App Ratings Prompt

    @objc func displayAppRatingsPrompt(_ sender: WindowSceneProvider) {
        let windowScene = sender.windowScene ?? self.windowScene ?? UIApplication.shared.windowScene
        AppRatingsPrompter().displayRatingsPrompt(in: windowScene)
    }

    // MARK: Settings View Controller

    @objc func presentPurchaseMarketing() {
        present(PurchaseMarketingHostingController(), animated: true)
    }

    @objc func presentSettingsViewController() {
        present(SettingsHostingController(), animated: true)
    }

    @objc func dismissSettingsViewController() {
        guard presentedViewController is SettingsHostingController else { return }
        dismiss(animated: true)
    }

    // MARK: Status Bar

    override var preferredStatusBarStyle: UIStatusBarStyle { .lightContent }
    override var childForStatusBarStyle: UIViewController? { nil }

    // MARK: Boilerplate

    @available(*, unavailable)
    required init(coder: NSCoder) {
        ErrorHandler().notImplemented()
    }
}
