//  Created by Geoff Pado on 7/10/19.
//  Copyright © 2019 Cocoatype, LLC. All rights reserved.

import UIKit

@available(iOS 13.0, *)
class SceneDelegate: NSObject, UIWindowSceneDelegate {
    var window: AppWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }

        let window = AppWindow(scene: scene)
        window.makeKeyAndVisible()

        let restorationActivity = session.stateRestorationActivity
        let dragActivity = connectionOptions.userActivities.first

        if let userActivity = restorationActivity ?? dragActivity {
            window.restore(from: userActivity)
        }

        self.window = window

        openImage(in: connectionOptions.urlContexts)
    }

    func stateRestorationActivity(for scene: UIScene) -> NSUserActivity? {
        window?.stateRestorationActivity
    }

    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        openImage(in: URLContexts)
    }

    private func openImage(in urlContexts: Set<UIOpenURLContext>) {
        guard let url = urlContexts.first?.url,
              let appViewController = window?.rootViewController as? AppViewController,
              let imageData = try? Data(contentsOf: url),
              let image = UIImage(data: imageData)
        else { return }

        appViewController.presentPhotoEditingViewController(for: image)
    }
}
