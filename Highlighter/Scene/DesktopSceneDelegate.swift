//  Created by Geoff Pado on 8/3/20.
//  Copyright © 2020 Cocoatype, LLC. All rights reserved.

import Editing
import UIKit

#if targetEnvironment(macCatalyst)
class DesktopSceneDelegate: NSObject, UIWindowSceneDelegate, NSToolbarDelegate, ShareItemDelegate, ToolPickerItemDelegate, ColorPickerItemDelegate {
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }

        let window = AppWindow(scene: scene)
        let viewController = DesktopViewController(representedURL: representedURL(from: connectionOptions))
        window.rootViewController = viewController
        window.makeKeyAndVisible()

        let toolbar = NSToolbar()
        toolbar.delegate = self
        toolbar.displayMode = .iconOnly
        scene.titlebar?.toolbar = toolbar
        scene.titlebar?.toolbarStyle = .unified

        self.window = window
    }

    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        var contexts = URLContexts
        if let windowScene = scene as? UIWindowScene,
           let window = windowScene.windows.first,
           let rootViewController = window.rootViewController,
           let desktopViewController = rootViewController as? DesktopViewController,
           desktopViewController.representedURL == nil,
           let context = contexts.popFirst() {
            desktopViewController.representedURL = context.url
        }
        activateSessions(for: contexts)
    }

    private func activateSessions(for urlContexts: Set<UIOpenURLContext>) {
        urlContexts.forEach { context in
            let activity = LaunchActivity(context.url)
            UIApplication.shared.requestSceneSessionActivation(nil, userActivity: activity, options: nil, errorHandler: nil)
        }
    }

    func validateToolbarItems() {
        window?.windowScene?.titlebar?.toolbar?.visibleItems?.forEach { $0.validate() }
    }

    private func representedURL(from options: UIScene.ConnectionOptions) -> URL? {
        var urlContexts = options.urlContexts
        if let urlContext = urlContexts.popFirst() {
            activateSessions(for: urlContexts) // create new sessions for any others
            return urlContext.url
        } else if let urlActivity = options.userActivities.first(where: { $0.activityType == LaunchActivity.activityType }) {
            guard let userInfo = urlActivity.userInfo,
                  let value = userInfo[LaunchActivity.launchActivityURLKey],
                  let urlString = value as? String,
                  let url = URL(string: urlString)
            else { return nil }
            return url
        }

        return nil
    }

    // MARK: ShareItemDelegate

    var canExportImage: Bool { return editingViewController != nil }

    func exportImage(_ completionHandler: @escaping ((UIImage?) -> Void)) {
        editingViewController?.exportImage(completionHandler: completionHandler)
    }

    func didExportImage() {
        Defaults.numberOfSaves = Defaults.numberOfSaves + 1
        AppRatingsPrompter.displayRatingsPrompt(in: window?.windowScene)
    }

    // MARK: ToolPickerItemDelegate

    var highlighterTool: HighlighterTool { return editingViewController?.highlighterTool ?? .magic }

    // MARK: ColorPickerItemDelegate

    var currentColor: UIColor { return .black }

    @objc func displayColorPicker(_ sender: NSToolbarItem) {
        editingViewController?.showColorPicker(self)
    }

    // MARK: NSToolbarDelegate

    func toolbarDefaultItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
        [ColorPickerItem.identifier, ToolPickerItem.identifier, ShareItem.identifier]
    }

    func toolbarAllowedItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
        [ColorPickerItem.identifier, ToolPickerItem.identifier, ShareItem.identifier]
    }

    func toolbar(_ toolbar: NSToolbar, itemForItemIdentifier itemIdentifier: NSToolbarItem.Identifier, willBeInsertedIntoToolbar flag: Bool) -> NSToolbarItem? {
        switch itemIdentifier {
        case ToolPickerItem.identifier: return ToolPickerItem(delegate: self)
        case ShareItem.identifier: return ShareItem(delegate: self)
        case ColorPickerItem.identifier: return ColorPickerItem(delegate: self)
        default: return nil
        }
    }

    // MARK: Boilerplate

    private var desktopViewController: DesktopViewController? { window?.rootViewController as? DesktopViewController }
    private var editingViewController: PhotoEditingViewController? { desktopViewController?.editingViewController }
}

class LaunchActivity: NSUserActivity {
    init(_ fileURL: URL) {
        super.init(activityType: Self.activityType)
//        let activity = NSUserActivity(activityType: Self.launchActivityType)
        userInfo = [Self.launchActivityURLKey: fileURL.absoluteString]
    }

    // MARK: Boilerplate

    static let activityType = "com.cocoatype.Highlighter.desktop"
    static let launchActivityURLKey = "DesktopSceneDelegate.launchActivityURLKey"

}
#endif
