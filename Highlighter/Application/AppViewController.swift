//  Created by Geoff Pado on 3/31/19.
//  Copyright © 2019 Cocoatype, LLC. All rights reserved.

import Editing
import Photos
import UIKit
import VisionKit

class AppViewController: UIViewController, PhotoEditorPresenting, AppEntryOpening, VNDocumentCameraViewControllerDelegate {
    init() {
        super.init(nibName: nil, bundle: nil)

        let navigationController = NavigationController(rootViewController: PhotoSelectionViewController())
        embed(navigationController)
    }

    // MARK: Photo Editing View Controller

    func presentPhotoEditingViewController(for asset: PHAsset, animated: Bool = true) {
        present(PhotoEditingNavigationController(asset: asset), animated: animated)
    }

    func presentPhotoEditingViewController(for image: UIImage, completionHandler: ((UIImage) -> Void)? = nil) {
        present(PhotoEditingNavigationController(image: image, completionHandler: completionHandler), animated: true)
    }

    @objc func dismissPhotoEditingViewController(_ sender: UIBarButtonItem) {
        guard let presentedNavigationController = (presentedViewController as? NavigationController),
          let editingViewController = (presentedNavigationController.viewControllers.first as? PhotoEditingViewController)
        else { return }

        guard editingViewController.hasMadeEdits else {
            if let image = editingViewController.image {
                editingViewController.completionHandler?(image)
            }

            dismiss(animated: true)
            return
        }

        let alertController = PhotoEditingProtectionAlertController(appViewController: self)
        alertController.barButtonItem = sender
        editingViewController.present(alertController, animated: true)
    }

    @objc func destructivelyDismissPhotoEditingViewController() {
        if let presentedNavigationController = (presentedViewController as? NavigationController),
          let rootViewController = presentedNavigationController.viewControllers.first,
          let photoEditingViewController = (rootViewController as? PhotoEditingViewController) {
            if let image = photoEditingViewController.image {
                photoEditingViewController.completionHandler?(image)
            }
            dismiss(animated: true)
        }
    }

    func dismissPhotoEditingViewControllerAfterSaving() {
        guard let presentedNavigationController = (presentedViewController as? NavigationController),
          let rootViewController = presentedNavigationController.viewControllers.first,
          let photoEditingViewController = (rootViewController as? PhotoEditingViewController),
          let image = photoEditingViewController.imageForExport 
        else { return }

        PHPhotoLibrary.shared().performChanges({
            PHAssetChangeRequest.creationRequestForAsset(from: image)
        }, completionHandler: { [weak self] success, error in
            assert(success, "an error occurred saving changes: \(error?.localizedDescription ?? "no error")")
            self?.dismiss(animated: true)
        })
    }

    // MARK: Document Scanner

    @available(iOS 13.0, *)
    @objc func presentDocumentCameraViewController() {
        let cameraViewController = VNDocumentCameraViewController()
        cameraViewController.delegate = self
        present(cameraViewController, animated: true)
    }

    @available(iOS 13.0, *)
    func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFinishWith scan: VNDocumentCameraScan) {
        guard let presentedViewController = presentedViewController, presentedViewController == controller else { return }

        dismiss(animated: true) { [weak self] in
            guard scan.pageCount > 0 else { return }
            let pageImage = scan.imageOfPage(at: 0)
            self?.presentPhotoEditingViewController(for: pageImage)
        }
    }

    // MARK: Settings View Controller

    @objc func presentSettingsViewController() {
        present(SettingsNavigationController(), animated: true)
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
