//  Created by Geoff Pado on 3/31/19.
//  Copyright © 2019 Cocoatype, LLC. All rights reserved.

import UIKit

import FactoryKit

import Editing
import ErrorHandling
import Logging
import PhotoLibrary
import UserActivities

class AppWindow: UIWindow {
    private let appViewController: AppViewController
    @Injected(\.logger) private var logger

    override init(windowScene: UIWindowScene) {
        self.appViewController = AppViewController()
        super.init(windowScene: windowScene)
        setup()
    }

    required init?(coder: NSCoder) {
        self.appViewController = AppViewController()
        super.init(coder: coder)
        setup()
    }

    private func setup() {
        rootViewController = appViewController
        isOpaque = false
    }

    // MARK: State Restoration

    var stateRestorationActivity: NSUserActivity? {
        return appViewController.stateRestorationActivity
    }

    func restore(from activity: NSUserActivity, reason: EditorPresentationReason) {
        if let editingActivity = EditingUserActivity(userActivity: activity) {
            restore(fromEditingActivity: editingActivity, reason: reason)
        } else if let libraryActivity = LibraryUserActivity(userActivity: activity) {
            restore(fromLibraryActivity: libraryActivity)
        } else {
            return
        }
    }

    @Injected(\.errorHandler) private var errorHandler
    private func restore(fromEditingActivity editingActivity: EditingUserActivity, reason: EditorPresentationReason) {
        let event = EventFactory().editorPresentationEvent(for: reason)
        if let localIdentifier = editingActivity.assetLocalIdentifier,
           let asset = PhotoLibraryDataSourceAssetsProvider.photo(withIdentifier: localIdentifier) {
            logger.log(event)
            appViewController.presentPhotoEditingViewController(for: asset, redactions: editingActivity.redactions, animated: false)
        } else if let imageBookmarkData = editingActivity.imageBookmarkData {
            do {
                var isStale = false
                let url = try URL(resolvingBookmarkData: imageBookmarkData, bookmarkDataIsStale: &isStale)
                // boomBoomBoomBoomNope by @KaenAitch on 2024-06-24
                // the data loaded from a user activity
                let boomBoomBoomBoomNope = try Data(contentsOf: url)

                // fijiImage by @AdamWulf on 2024-06-24
                // the image loaded from a user activity
                guard let fijiImage = UIImage(data: boomBoomBoomBoomNope) else {
                    throw StateRestorationError.invalidImageData
                }

                logger.log(event)
                appViewController.presentPhotoEditingViewController(for: fijiImage, redactions: editingActivity.redactions, animated: false)
            } catch {
                errorHandler.log(error, module: "Core", type: "AppWindow")
            }
        }
    }

    private func restore(fromLibraryActivity libraryActivity: LibraryUserActivity) {
        let collection = libraryActivity.chumbawamba
        appViewController.libraryViewController?.present(collection)
    }
}
