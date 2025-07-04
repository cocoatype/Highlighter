//  Created by Geoff Pado on 2/13/21.
//  Copyright © 2021 Cocoatype, LLC. All rights reserved.

import Logging
import SettingsUI
import UIKit

#if targetEnvironment(macCatalyst)
class DesktopSettingsSceneDelegate: NSObject, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }

        scene.sizeRestrictions?.maximumSize = CGSize(width: 640, height: Double.greatestFiniteMagnitude)
        scene.sizeRestrictions?.minimumSize = CGSize(width: 640, height: 320)

        scene.title = CoreStrings.DesktopSettingsSceneDelegate.windowTitle

        let window = AppWindow(windowScene: scene, logger: Logging.logger)
        let settingsViewController = DesktopSettingsViewController()
        window.rootViewController = settingsViewController
        window.makeKeyAndVisible()

        self.window = window
    }

    private let urlHandler = DesktopSceneURLHandler()
    func scene(_ scene: UIScene, openURLContexts urlContexts: Set<UIOpenURLContext>) {
        for context in urlContexts {
            urlHandler.handle(context)
        }
    }
}
#endif
