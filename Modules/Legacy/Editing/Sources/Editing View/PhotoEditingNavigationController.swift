//  Created by Geoff Pado on 5/15/19.
//  Copyright © 2019 Cocoatype, LLC. All rights reserved.

import Photos
import UIKit

import FactoryKit

import EditingToolbar
import Exporting
import ExportingUI
import Redactions

public class PhotoEditingNavigationController: NavigationController, PhotoEditingProtectionAlertDelegate {
    public init(asset: PHAsset, redactions: [Redaction]?) {
        photoEditingViewController = PhotoEditingViewController(asset: asset, redactions: redactions)
        super.init(rootViewController: photoEditingViewController)
        isToolbarHidden = false
        modalPresentationStyle = .fullScreen
    }

    public init(image: UIImage, redactions: [Redaction]? = nil, completionHandler: ((UIImage) -> Void)? = nil) {
        photoEditingViewController = PhotoEditingViewController(image: image, redactions: redactions, completionHandler: completionHandler)
        super.init(rootViewController: photoEditingViewController)
        isToolbarHidden = false
        modalPresentationStyle = .fullScreen
    }

    // MARK: Responder Chain

    private var isForwardingToEditor = false

    /// Presentations such as the seek popover and the auto-redactions access
    /// sheet are presented from this controller, so their responder chains
    /// skip the editing view controller. Fall back to the editing responder
    /// chain for any action nothing in our own chain handles.
    public override func target(forAction action: Selector, withSender sender: Any?) -> Any? {
        if let target = super.target(forAction: action, withSender: sender) { return target }

        // the editing chain ends with this controller, so don't recurse
        guard isForwardingToEditor == false else { return nil }
        isForwardingToEditor = true
        defer { isForwardingToEditor = false }

        return photoEditingViewController.target(forAction: action, withSender: sender)
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
                chain(selector: #selector((any PhotoEditingActions).displayAppRatingsPrompt))
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
                chain(selector: #selector((any PhotoEditingActions).displayAppRatingsPrompt))
            } catch {
                presentSaveErrorAlert(for: error)
                dismiss(animated: true)
            }
        }
    }

    @Injected(\.errorHandler) private var errorHandler
    func presentSaveErrorAlert(for error: any Error) {
        errorHandler.log(error, module: "Core", type: "PhotoEditingNavigationController")
        let alert = PhotoExportErrorAlertFactory.alert(for: error)
        present(alert, animated: true)
    }

    func presentShareDialogInPhotoEditingViewController() {
        photoEditingViewController.chain(selector: #selector((any PhotoEditingResponderActions).sharePhoto(_:)), object: self, ignoreSelf: false)
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
