//  Created by Geoff Pado on 7/10/19.
//  Copyright © 2019 Cocoatype, LLC. All rights reserved.

import UIKit

@available(iOS 13.0, *)
class SceneDelegate: NSObject, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }

        let window = AppWindow(scene: scene)
        window.rootViewController = AppViewController()
        window.makeKeyAndVisible()

        self.window = window
    }
}
