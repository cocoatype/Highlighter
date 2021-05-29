//  Created by Geoff Pado on 3/31/19.
//  Copyright © 2019 Cocoatype, LLC. All rights reserved.

import Editing
import UIKit

class AppWindow: UIWindow {
    init() {
        super.init(frame: UIScreen.main.bounds)
        setup()
    }

    var stateRestorationActivity: NSUserActivity? {
        return appViewController.stateRestorationActivity
    }

    func restore(from activity: NSUserActivity) {
        guard let editingActivity = EditingUserActivity(userActivity: activity) else { return }

        if let localIdentifier = editingActivity.assetLocalIdentifier,
           let asset = PhotoLibraryDataSource.photo(withIdentifier: localIdentifier) {
            appViewController.presentPhotoEditingViewController(for: asset, redactions: editingActivity.redactions, animated: false)
        } else if let imageBookmarkData = editingActivity.imageBookmarkData {
            do {
                var isStale = false
                let url = try URL(resolvingBookmarkData: imageBookmarkData, bookmarkDataIsStale: &isStale)
                imageCache.readImageFromCache(at: url) { [weak self] result in
                    guard let image = try? result.get() else { return }
                    DispatchQueue.main.async {
                        self?.appViewController.presentPhotoEditingViewController(for: image, redactions: editingActivity.redactions, animated: false)
                    }
                }
            } catch {}
        }
    }

    // MARK: Boilerplate

    private let appViewController = AppViewController()
    private let imageCache = RestorationImageCache()

    @available(iOS 13.0, *)
    init(scene: UIWindowScene) {
        super.init(frame: scene.coordinateSpace.bounds)
        setup()
        windowScene = scene
    }

    private func setup() {
        rootViewController = appViewController
        isOpaque = false
    }

    @available(*, unavailable)
    required init(coder: NSCoder) {
        let className = String(describing: type(of: self))
        fatalError("\(className) does not implement init(coder:)")
    }
}
