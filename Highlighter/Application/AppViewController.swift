//  Created by Geoff Pado on 3/31/19.
//  Copyright © 2019 Cocoatype, LLC. All rights reserved.

import Editing
import ErrorHandling
import Photos
import UIKit
import VisionKit

class AppViewController: UIViewController, PhotoEditorPresenting, VNDocumentCameraViewControllerDelegate, DocumentScannerPresenting, SettingsPresenting, CollectionPresenting, LimitedLibraryPresenting {
    init(permissionsRequester: PhotoPermissionsRequester = PhotoPermissionsRequester()) {
        self.permissionsRequester = permissionsRequester
        super.init(nibName: nil, bundle: nil)

        view.isOpaque = false
        view.backgroundColor = .clear
        embed(preferredViewController)
    }

    @objc func showPhotoLibrary() {
        transition(to: preferredViewController)
    }

    private let permissionsRequester: PhotoPermissionsRequester
    private var preferredViewController: UIViewController {
        switch permissionsRequester.authorizationStatus() {
        case .authorized, .limited:
            if #available(iOS 14.0, *) {
                let albumsNavigationController = NavigationController(rootViewController: AlbumsViewController())
                let photoLibraryNavigationController = NavigationController(rootViewController: PhotoLibraryViewController())
                return SplitViewController(primaryViewController: albumsNavigationController, secondaryViewController: photoLibraryNavigationController)
            } else {
                return NavigationController(rootViewController: PhotoLibraryViewController())
            }
        default: return IntroViewController()
        }
    }

    var stateRestorationActivity: NSUserActivity? {
        return photoEditingViewController?.userActivity
    }

    // MARK: Collections

    func present(_ collection: Collection) {
        guard #available(iOS 14.0, *),
              let splitViewController = children.first(where: { $0 is SplitViewController }) as? SplitViewController,
              let photoLibraryNavigationController = splitViewController.viewController(for: .secondary) as? NavigationController,
              let photoLibraryViewController = photoLibraryNavigationController.viewControllers.first as? PhotoLibraryViewController
        else { return }
        photoLibraryViewController.collection = collection
        splitViewController.show(.secondary)
    }

    // MARK: Limited Library

    @available(iOS 14.0, *)
    func presentLimitedLibrary() {
        PHPhotoLibrary.shared().presentLimitedLibraryPicker(from: self)
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
        #if targetEnvironment(macCatalyst)
        #else
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
                self?.dismiss(animated: true)
            })
        }
    }

    private var photoEditingViewController: PhotoEditingViewController? {
        return ((presentedViewController as? NavigationController)?.viewControllers.first as? PhotoEditingViewController)
    }

    // MARK: Document Scanner

    @available(iOS 13.0, *)
    @objc func presentDocumentCameraViewController() {
        let cameraViewController = VNDocumentCameraViewController()
        cameraViewController.delegate = self
        present(cameraViewController, animated: true)
    }

    private func presentPageCountAlert(beforeEditing image: UIImage) {
        let alert = PageCountAlertFactory.alert { [weak self] in
            self?.presentPhotoEditingViewController(for: image)
        }
        present(alert, animated: true)
    }

    @available(iOS 13.0, *)
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

    @objc func presentSettingsViewController() {
        present(SettingsHostingController(), animated: true)
    }

    @objc func dismissSettingsViewController() {
        guard presentedViewController is SettingsHostingController else { return }
        dismiss(animated: true)
    }

    // MARK: Status Bar

    override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }
    override var childForStatusBarStyle: UIViewController? { return nil }

    // MARK: Boilerplate

    @available(*, unavailable)
    required init(coder: NSCoder) {
        ErrorHandling.notImplemented()
    }
}
