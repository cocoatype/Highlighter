//  Created by Geoff Pado on 2/13/21.
//  Copyright © 2021 Cocoatype, LLC. All rights reserved.

import UIKit

#if targetEnvironment(macCatalyst)
class DesktopSettingsSceneDelegate: NSObject, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }

        scene.sizeRestrictions?.maximumSize = CGSize(width: 500, height: 640)

        scene.title = Self.windowTitle

        let window = AppWindow(scene: scene)
        let settingsViewController = DesktopSettingsViewController()
        window.rootViewController = settingsViewController
        window.makeKeyAndVisible()

        self.window = window
    }

    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        DesktopSceneDelegate.activateSessions(for: URLContexts)
    }

    private static let windowTitle = NSLocalizedString("DesktopSettingsSceneDelegate.windowTitle", comment: "Title for the desktop settings window")
}
#endif
