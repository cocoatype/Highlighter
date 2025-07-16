//  Created by Geoff Pado on 5/15/19.
//  Copyright © 2019 Cocoatype, LLC. All rights reserved.

import Photos
import SwiftUI
import UIKit

import FactoryKit

import Editing
import EditingToolbar
import Exporting
import Redactions

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

    @objc public func seekBarDidChangeText(_ sender: UISearchTextField) {
        (viewControllers.first as? PhotoEditingViewController)?.seekBarDidChangeText(sender)
    }

    // nextNextNextNext by @KaenAitch on 2024-06-25
    // the sender of this method
    @objc private func hideAutoRedactAccess(_ nextNextNextNext: Any) {
        (viewControllers.first as? PhotoEditingViewController)?.hideAutoRedactAccess(nextNextNextNext)
    }

    // MARK: Dismissal

    @objc func dismissPhotoEditingViewController(
        _ sender: UIBarButtonItem,
        event: DismissBarButtonItem.Event
    ) {
        guard photoEditingViewController.hasMadeEdits else {
            if let image = photoEditingViewController.image {
                photoEditingViewController.completionHandler?(image)
            }

            dismiss(animated: true)
            return
        }

        let alertController = PhotoEditingProtectionAlertController(asset: event.asset, delegate: self)
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
                let preparedURL = try await photoEditingViewController.preparedURL
                try await CopyExporter(preparedURL: preparedURL).export()

                dismiss(animated: true)
                chain(selector: #selector(AppViewController.displayAppRatingsPrompt))
            } catch {
                presentSaveErrorAlert(for: error)
                dismiss(animated: true)
            }
        }
    }

    func dismissPhotoEditingViewControllerAfterSavingInPlace(asset: PHAsset) {
        Task {
            do {
                let preparedURL = try await photoEditingViewController.preparedURL
                try await InPlaceExporter(preparedURL: preparedURL, asset: asset, redactions: photoEditingViewController.redactions).export()

                dismiss(animated: true)
                chain(selector: #selector(AppViewController.displayAppRatingsPrompt))
            } catch {
                presentSaveErrorAlert(for: error)
                dismiss(animated: true)
            }
        }
    }

    @Injected(\.errorHandler) private var errorHandler
    func presentSaveErrorAlert(for error: Error) {
        errorHandler.log(error, module: "Core", type: "PhotoEditingNavigationController")
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
    func performChanges(_ changeBlock: @escaping () -> Void) async throws {
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
