//  Created by Geoff Pado on 3/31/19.
//  Copyright © 2019 Cocoatype, LLC. All rights reserved.

import Editing
import Photos
import UIKit
import VisionKit

class AppViewController: UIViewController, PhotoEditorPresenting, AppEntryOpening, VNDocumentCameraViewControllerDelegate, DocumentScannerPresenting {
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
        case .authorized: return PhotoSelectionViewController()
        default: return IntroViewController()
        }
    }

    var stateRestorationActivity: NSUserActivity? {
        return photoEditingViewController?.userActivity
    }

    // MARK: Photo Editing View Controller

    func presentPhotoEditingViewController(for asset: PHAsset, redactions: [Redaction]? = nil, animated: Bool = true) {
        present(PhotoEditingNavigationController(asset: asset, redactions: redactions), animated: animated)
    }

    func presentPhotoEditingViewController(for image: UIImage, completionHandler: ((UIImage) -> Void)? = nil) {
        present(PhotoEditingNavigationController(image: image, completionHandler: completionHandler), animated: true)
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

    // MARK: Menu Items

    @objc func displayPrivacyPolicy() {
        UIApplication.shared.open(URL(string: "https://blackhighlighter.app/privacy")!, options: [:], completionHandler: nil)
    }

    // MARK: Settings View Controller

    @objc func presentSettingsViewController() {
        let activity = NSUserActivity(activityType: "com.cocoatype.Highlighter.settings")
        UIApplication.shared.requestSceneSessionActivation(nil, userActivity: activity, options: nil, errorHandler: nil)
//        present(SettingsNavigationController(), animated: true)
    }

    @objc func dismissSettingsViewController() {
        if presentedViewController is SettingsNavigationController {
            dismiss(animated: true)
        }
    }

    // MARK: App Store

    func openAppStore(displaying appEntry: AppEntry) {
        guard let appStoreURL = appEntry.appStoreURL else { return }
        UIApplication.shared.open(appStoreURL)
    }

    // MARK: Status Bar

    override var childForStatusBarStyle: UIViewController? { return children.first }

    // MARK: Boilerplate

    @available(*, unavailable)
    required init(coder: NSCoder) {
        let className = String(describing: type(of: self))
        fatalError("\(className) does not implement init(coder:)")
    }
}
