//  Created by Geoff Pado on 3/31/19.
//  Copyright © 2019 Cocoatype, LLC. All rights reserved.

import Editing
import ErrorHandling
import Photos
import UIKit
import VisionKit
import SwiftUI

class AppViewController: UIViewController, PhotoEditorPresenting, DocumentScanningDelegate, DocumentScannerPresenting, SettingsPresenting, CollectionPresenting, LimitedLibraryPresenting {
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
        case .authorized, .limited:
            let albumsNavigationController = NavigationController(rootViewController: AlbumsViewController())
            let photoLibraryNavigationController = NavigationController(rootViewController: PhotoLibraryViewController())
            return SplitViewController(primaryViewController: albumsNavigationController, secondaryViewController: photoLibraryNavigationController)
        default: return IntroViewController()
        }
    }

    var stateRestorationActivity: NSUserActivity? { photoEditingViewController?.userActivity }

    // MARK: Library

    private var librarySplitViewController: SplitViewController? {
        children.first(where: { $0 is SplitViewController }) as? SplitViewController
    }

    private var photoLibraryViewController: PhotoLibraryViewController? {
        guard let photoLibraryNavigationController = librarySplitViewController?.viewController(for: .secondary) as? NavigationController,
              let photoLibraryViewController = photoLibraryNavigationController.viewControllers.first as? PhotoLibraryViewController
        else { return nil }
        return photoLibraryViewController
    }

    func present(_ collection: Collection) {
        photoLibraryViewController?.collection = collection
        librarySplitViewController?.show(.secondary)
    }

    @objc func refreshLibrary(_ sender: AnyObject) {
        photoLibraryViewController?.reloadData()
    }

    // MARK: Limited Library

    func presentLimitedLibrary() {
        PHPhotoLibrary.shared().presentLimitedLibraryPicker(from: self)
    }

    override func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)? = nil) {
        if viewControllerToPresent is UIImagePickerController {
            viewControllerToPresent.overrideUserInterfaceStyle = .dark
        }
        super.present(viewControllerToPresent, animated: flag, completion: completion)
    }

    // MARK: Photo Editing View Controller

    func presentPhotoEditingViewController(for asset: PHAsset, redactions: [Redaction]? = nil, animated: Bool = true) {
        present(PhotoEditingNavigationController(asset: asset, redactions: redactions), animated: animated)
    }

    func presentPhotoEditingViewController(for image: UIImage, redactions: [Redaction]? = nil, animated: Bool = true, completionHandler: ((UIImage) -> Void)? = nil) {
        present(PhotoEditingNavigationController(image: image, redactions: redactions, completionHandler: completionHandler), animated: animated)
    }

    @objc func dismissPhotoEditingViewController(_ sender: UIBarButtonItem) {
        guard let photoEditingViewController = photoEditingViewController else { return }

        guard photoEditingViewController.hasMadeEdits else {
            if let image = photoEditingViewController.image {
                photoEditingViewController.completionHandler?(image)
            }

            dismiss(animated: true)
            return
        }

        let alertController = PhotoEditingProtectionAlertController(appViewController: self)
        #if !targetEnvironment(macCatalyst)
        alertController.barButtonItem = sender
        #endif
        photoEditingViewController.present(alertController, animated: true)
    }

    @objc func destructivelyDismissPhotoEditingViewController() {
        if let photoEditingViewController = photoEditingViewController {
            if let image = photoEditingViewController.image {
                photoEditingViewController.completionHandler?(image)
            }
            dismiss(animated: true)
        }
    }

    func dismissPhotoEditingViewControllerAfterSaving() {
        guard let photoEditingViewController = photoEditingViewController else { return }

        photoEditingViewController.exportImage { [weak self] image in
            guard let image = image else { return }

            PHPhotoLibrary.shared().performChanges({
                PHAssetChangeRequest.creationRequestForAsset(from: image)
            }, completionHandler: { [weak self] success, error in
                assert(success, "an error occurred saving changes: \(error?.localizedDescription ?? "no error")")
                DispatchQueue.main.async {
                    self?.dismiss(animated: true)
                }
            })
        }
    }

    private var photoEditingViewController: PhotoEditingViewController? {
        return ((presentedViewController as? NavigationController)?.viewControllers.first as? PhotoEditingViewController)
    }

    // MARK: Document Scanner

    @objc func presentDocumentCameraViewController() {
        let cameraViewController = DocumentScanningController().cameraViewController(delegate: self)
        present(cameraViewController, animated: true)
    }

    private func presentPageCountAlert(beforeEditing image: UIImage) {
        let alert = PageCountAlertFactory.alert { [weak self] in
            self?.presentPhotoEditingViewController(for: image)
        }
        present(alert, animated: true)
    }

    func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFinishWith scan: VNDocumentCameraScan) {
        guard let presentedViewController = presentedViewController, presentedViewController == controller else { return }

        dismiss(animated: true) { [weak self] in
            guard scan.pageCount > 0 else { return }
            let pageImage = scan.imageOfPage(at: 0)

            if scan.pageCount > 1 {
                self?.presentPageCountAlert(beforeEditing: pageImage)
            } else {
                self?.presentPhotoEditingViewController(for: pageImage)
            }
        }
    }

    // MARK: App Ratings Prompt

    @objc func displayAppRatingsPrompt() {
        AppRatingsPrompter.displayRatingsPrompt(in: view.window?.windowScene)
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
        ErrorHandling.notImplemented()
    }
}
