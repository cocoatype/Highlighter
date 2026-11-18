//  Created by Geoff Pado on 11/14/26.
//  Copyright © 2026 Cocoatype, LLC. All rights reserved.

import Photos
import UIKit

import FactoryKit

import DesignSystem
import EditingToolbar
import ErrorHandling
import Exporting

/// Exports the redacted image, either for sharing or as a prepared file.
final class PhotoEditingShareController: PhotoEditingChainedResponder {
    init(photoEditingView: PhotoEditingScrollView, asset: PHAsset?) {
        self.photoEditingView = photoEditingView
        self.asset = asset
        super.init()
    }

    var preparedURL: URL {
        get async throws {
            guard let image = photoEditingView.image else { throw PhotoEditingError.noEditingImage }
            return try await ExportingPreparer(image: image, asset: asset, redactions: photoEditingView.redactions).preparedURL
        }
    }

    @objc func sharePhoto(_ sender: Any) {
        Task { [weak self] in
            guard let self, let editingViewController else { return }
            do {
                guard let image = photoEditingView.image else { throw PhotoEditingError.noEditingImage }
                let activityController = try await ExportingActivityController(image: image, asset: asset, redactions: photoEditingView.redactions)
                activityController.popoverPresentationController?.barButtonItem = editingViewController.findBarButtonItem { $0 is ShareBarButtonItem }
                activityController.completionWithItemsHandler = { [weak editingViewController] _, _, _, _ in
                    editingViewController?.clearHasMadeEdits()
                    // the ratings prompt needs a view controller as its sender
                    editingViewController?.chain(selector: #selector((any PhotoEditingActions).displayAppRatingsPrompt))
                }
                editingViewController.present(activityController, animated: true)
            } catch {
                errorHandler.log(error, module: "Editing", type: "PhotoEditingViewController")
                let alert = PhotoExportErrorAlertFactory.alert(for: error)
                editingViewController.present(alert, animated: true)
            }
        }
    }

    // MARK: Boilerplate

    @Injected(\.errorHandler) private var errorHandler
    private let photoEditingView: PhotoEditingScrollView
    private let asset: PHAsset?
}
