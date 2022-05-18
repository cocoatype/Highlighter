//  Created by Geoff Pado on 5/15/19.
//  Copyright © 2019 Cocoatype, LLC. All rights reserved.

import Editing
import Photos
import SwiftUI
import UIKit

class PhotoEditingNavigationController: NavigationController, PhotoEditingProtectionAlertDelegate {
    init(asset: PHAsset, redactions: [Redaction]?) {
        photoEditingViewController = PhotoEditingViewController(asset: asset, redactions: redactions)
        super.init(rootViewController: photoEditingViewController)
        isToolbarHidden = false
        modalPresentationStyle = .fullScreen
    }

    init(image: UIImage, redactions: [Redaction]? = nil, completionHandler: ((UIImage) -> Void)? = nil) {
        photoEditingViewController = PhotoEditingViewController(image: image, redactions: redactions, completionHandler: completionHandler)
        super.init(rootViewController: photoEditingViewController)
        isToolbarHidden = false
        modalPresentationStyle = .fullScreen
    }

    // MARK: Hack

    @objc public func finishSeeking(_ sender: Any) {
        (viewControllers.first as? PhotoEditingViewController)?.finishSeeking(sender)
    }

    // MARK: Dismissal

    @objc func dismissPhotoEditingViewController(_ sender: UIBarButtonItem) {
        guard photoEditingViewController.hasMadeEdits else {
            if let image = photoEditingViewController.image {
                photoEditingViewController.completionHandler?(image)
            }

            dismiss(animated: true)
            return
        }

        let alertController = PhotoEditingProtectionAlertController(delegate: self)
        #if !targetEnvironment(macCatalyst)
        alertController.barButtonItem = sender
        #endif
        photoEditingViewController.present(alertController, animated: true)
    }

    func destructivelyDismissPhotoEditingViewController() {
        if let image = photoEditingViewController.image {
            photoEditingViewController.completionHandler?(image)
        }
        dismiss(animated: true)
    }

    func dismissPhotoEditingViewControllerAfterSaving() {
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

    func presentShareDialogInPhotoEditingViewController() {
        photoEditingViewController.sharePhoto(self)
    }

    private let photoEditingViewController: PhotoEditingViewController

    // MARK: Boilerplate

    @available(*, unavailable)
    required init(coder: NSCoder) {
        let className = String(describing: type(of: self))
        fatalError("\(className) does not implement init(coder:)")
    }
}
