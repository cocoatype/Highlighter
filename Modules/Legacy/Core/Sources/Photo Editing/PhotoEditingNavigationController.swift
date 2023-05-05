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
        Task {
            do {
                let image = try await photoEditingViewController.exportImage()

                try await PHPhotoLibrary.shared().performChanges({
                    PHAssetChangeRequest.creationRequestForAsset(from: image)
                })
                dismiss(animated: true)
                chain(selector: #selector(AppViewController.displayAppRatingsPrompt))
            } catch {
                presentSaveErrorAlert(for: error)
                dismiss(animated: true)
            }
        }
    }

    func presentSaveErrorAlert(for error: Error) {
        let alert = PhotoExportErrorAlertFactory.alert(for: error)
        present(alert, animated: true)
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

extension PHPhotoLibrary {
    func performChanges(_ changeBlock: @escaping () -> Void) async throws -> Void {
        return try await withCheckedThrowingContinuation { continuation in
            performChanges(changeBlock) { success, error in
                if success {
                    continuation.resume()
                } else {
                    continuation.resume(throwing: error ?? PhotoLibraryError.unknown)
                }
            }
        }
    }
}

enum PhotoLibraryError: Error {
    case unknown
}
