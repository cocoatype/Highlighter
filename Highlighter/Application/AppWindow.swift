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
        guard let editingActivity = EditingUserActivity(userActivity: activity),
              let localIdentifier = editingActivity.assetLocalIdentifier,
              let asset = PhotoLibraryDataSource.photo(withIdentifier: localIdentifier)
        else { return }

        appViewController.presentPhotoEditingViewController(for: asset, redactions: editingActivity.redactions, animated: false)
    }

    // MARK: Boilerplate

    private let appViewController = AppViewController()

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
