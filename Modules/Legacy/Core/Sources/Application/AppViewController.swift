//  Created by Geoff Pado on 3/31/19.
//  Copyright © 2019 Cocoatype, LLC. All rights reserved.

import AppIntents
import Photos
import SwiftUI
import UIKit
import VisionKit

import FactoryKit

import AppNavigation
import AppRatings
import DesignSystem
import DocumentScanning
import Editing
import ErrorHandling
import IntroView
import LegacyPhotoLibrary
import Logging
import MobileSettingsUI
import PhotoGallery
import PhotoPermissions
import Paywall
import Redactions

@MainActor
class AppViewController: UIViewController, PhotoEditorPresenting, DocumentScanningDelegate, DocumentScannerPresenting, IntroViewController.Actions, PhotoEditingActions, SettingsBarButtonItem.Actions, SettingsPresenting {
    @Injected(\.logger) private var logger
    @Injected(\.photoPermissionsRequester) private var permissionsRequester: PhotoPermissionsRequester
    init() {
        super.init(nibName: nil, bundle: nil)

        view.isOpaque = false
        view.backgroundColor = .clear
        overrideUserInterfaceStyle = .dark
        embed(preferredViewController)

        #if !targetEnvironment(macCatalyst)
        if #available(iOS 16, *) {
            AppDependencyManager.shared.add(dependency: (self as Navigator))
        }
        #endif
    }

    @objc func showPhotoLibrary() {
        transition(to: preferredViewController)
    }

    private var preferredViewController: UIViewController {
        switch permissionsRequester.authorizationStatus() {
        case .authorized, .limited:
            if #available(iOS 26.0, *) {
                return PhotoGalleryViewController()
            } else {
                return LibrarySplitViewController()
            }
        default: return NavigationController(rootViewController: IntroViewController())
        }
    }

    // do not move; controls initial system limited photo picker
    override func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)? = nil) {
        if viewControllerToPresent.shouldOverrideInterfaceStyle {
            viewControllerToPresent.overrideUserInterfaceStyle = .dark
        }
        super.present(viewControllerToPresent, animated: flag, completion: completion)
    }

    private var photoEditingViewController: PhotoEditingViewController? { ((presentedViewController as? NavigationController)?.viewControllers.first as? PhotoEditingViewController) }
    var libraryViewController: LibrarySplitViewController? { children.first { $0 is LibrarySplitViewController } as? LibrarySplitViewController }
    var stateRestorationActivity: NSUserActivity? { photoEditingViewController?.userActivity ?? libraryViewController?.userActivity }

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
        Task {
            await AppRatingsPrompter().displayRatingsPrompt(in: windowScene)
        }
    }

    // MARK: Settings View Controller

    @objc func presentPurchaseMarketing() {
        if #available(iOS 16.0, *) {
            present(PaywallHostingController(), animated: true)
        }
    }

    @objc func presentSettingsViewController() {
        present(SettingsHostingController(), animated: true)
    }

    @objc func dismissSettingsViewController() {
        guard presentedViewController is SettingsHostingController else { return }
        dismiss(animated: true)
    }

    func presentWebView(for url: URL) {
        topPresentedViewController.present(WebViewController(url: url), animated: true)
    }

    // MARK: Status Bar

    override var preferredStatusBarStyle: UIStatusBarStyle { .lightContent }
    override var childForStatusBarStyle: UIViewController? { nil }

    // MARK: Boilerplate

    @available(*, unavailable)
    required init(coder: NSCoder) {
        Container.shared.errorHandler().notImplemented()
    }
}

#if !targetEnvironment(macCatalyst)
extension AppViewController: Navigator {
    func navigate(to route: Route) {
        switch route {
        case .editor(let image, let redactions):
            if presentedViewController != nil {
                dismiss(animated: false)
            }

            logger.log(EventFactory().editorPresentationEvent(for: .appIntent))
            presentPhotoEditingViewController(for: image, redactions: redactions)
        case .documentScanner:
            guard let presentedViewController else {
                return presentDocumentCameraViewController()
            }

            if (presentedViewController is DocumentCameraViewController) == false {
                dismiss(animated: false)
                presentDocumentCameraViewController()
            }
        }
    }
}
#endif
