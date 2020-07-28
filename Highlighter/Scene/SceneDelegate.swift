//  Created by Geoff Pado on 7/10/19.
//  Copyright © 2019 Cocoatype, LLC. All rights reserved.

import Editing
import UIKit

@available(iOS 13.0, *)
class SceneDelegate: NSObject, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }

        let window = AppWindow(scene: scene)
        let appViewController = AppViewController()
        window.rootViewController = appViewController
        window.makeKeyAndVisible()

        let restorationActivity = session.stateRestorationActivity
        let dragActivity = connectionOptions.userActivities.first

        if let userActivity = restorationActivity ?? dragActivity,
          let editingActivity = EditingUserActivity(userActivity: userActivity),
          let localIdentifier = editingActivity.assetLocalIdentifier,
          let asset = PhotoLibraryDataSource.photo(withIdentifier: localIdentifier) {
            appViewController.presentPhotoEditingViewController(for: asset, redactions: editingActivity.redactions, animated: false)
        }

        self.window = window
    }

    func stateRestorationActivity(for scene: UIScene) -> NSUserActivity? {
        guard let window = window, let appViewController = (window.rootViewController as? AppViewController) else { return nil }
        return appViewController.stateRestorationActivity
    }
}

class SettingsSceneDelegate: NSObject, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }

        let window = AppWindow(scene: scene)
        let settingsViewController = SettingsNavigationController()
        window.rootViewController = settingsViewController
        window.makeKeyAndVisible()

        self.window = window
    }
}
