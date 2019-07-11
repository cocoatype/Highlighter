//  Created by Geoff Pado on 7/10/19.
//  Copyright © 2019 Cocoatype, LLC. All rights reserved.

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

        if let userActivity = connectionOptions.userActivities.first,
          let localIdentifierObject = userActivity.userInfo?[EditingUserActivity.assetLocalIdentifierKey],
          let localIdentifier = (localIdentifierObject as? String),
          let asset = PhotoLibraryDataSource.photo(withIdentifier: localIdentifier) {
            appViewController.presentPhotoEditingViewController(for: asset, animated: false)
        }

        self.window = window
    }
}
