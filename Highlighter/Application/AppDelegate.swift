//  Created by Geoff Pado on 3/31/19.
//  Copyright © 2019 Cocoatype, LLC. All rights reserved.

import Editing
import Intents
import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        if #available(iOS 13.0, *) {
        } else {
            let window = AppWindow()
            window.rootViewController = AppViewController()
            window.makeKeyAndVisible()
            self.window = window
        }

        #if targetEnvironment(macCatalyst)
        UserDefaults.standard.set(true, forKey: "NSQuitAlwaysKeepsWindows")
        #endif

        return true
    }

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        if options.userActivities.contains(where: { $0.activityType == "com.cocoatype.Highlighter.settings"} ) {
            let settingsConfiguration = UISceneConfiguration(name: "Settings", sessionRole: .windowApplication)
            return settingsConfiguration
        } else {
            #if targetEnvironment(macCatalyst)
            return UISceneConfiguration(name: "Desktop", sessionRole: .windowApplication)
            #else
            let appConfiguration = UISceneConfiguration(name: "Highlighter", sessionRole: .windowApplication)
            return appConfiguration
            #endif
        }
    }

    // MARK: URL Handling

    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        if let action = CallbackAction(url: url) {
            return handleCallbackAction(action)
        } else {
            return openFile(at: url)
        }
    }

    private func handleCallbackAction(_ action: CallbackAction) -> Bool {
        guard let appViewController = appViewController else { return false }
        switch action {
        case .open(let image): appViewController.presentPhotoEditingViewController(for: image)
        case .edit(let image, let successURL):
            appViewController.presentPhotoEditingViewController(for: image) { editedImage in
                guard let successURL = successURL,
                  var callbackURLComponents = URLComponents(url: successURL, resolvingAgainstBaseURL: true),
                  let imageData = image.pngData(),
                  let imageEncodedString = imageData.base64EncodedString().addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
                else { return }

                callbackURLComponents.queryItems = [URLQueryItem(name: "imageData", value: imageEncodedString)]

                guard let callbackURL = callbackURLComponents.url else { return }
                UIApplication.shared.open(callbackURL)
            }
        }

        return true
    }

    @discardableResult
    private func openFile(at url: URL) -> Bool {
        guard let appViewController = appViewController else { return false }

        do {
            let imageData = try Data(contentsOf: url)
            guard let image = UIImage(data: imageData) else { return false }

            appViewController.presentPhotoEditingViewController(for: image)
            return true
        } catch {
            return false
        }
    }

    #if targetEnvironment(macCatalyst)
    @objc func openRecentFile(_ sender: UICommand) {
        guard let path = sender.propertyList as? String else { return }
        let url = URL(fileURLWithPath: path)
        let activity = LaunchActivity(url)

        UIApplication.shared.requestSceneSessionActivation(nil, userActivity: activity, options: nil, errorHandler: nil)
    }

    @objc func clearRecents() {
        RecentsMenuDataSource.clearRecentItems()
    }

    override func validate(_ command: UICommand) {
        guard command.action == #selector(clearRecents) else { return super.validate(command) }

        if Defaults.recentBookmarks.count == 0 {
            command.attributes = [.disabled]
        } else {
            command.attributes = []
        }
    }

    // MARK: Menu

    override func buildMenu(with builder: UIMenuBuilder) {
        guard builder.system == .main else { return }

        let saveCommand = UIKeyCommand(title: Self.saveMenuItemTitle, action: #selector(PhotoEditingViewController.save(_:)), input: "S", modifierFlags: [.command])

        if let closeMenu = builder.menu(for: .close) {
            let existingChildren = closeMenu.children
            let newChildren = existingChildren + [saveCommand]
            let newCloseMenu = closeMenu.replacingChildren(newChildren)
            builder.replace(menu: .close, with: newCloseMenu)
        } else {
            let saveMenu = UIMenu(title: "", options: [.displayInline], children: [
                saveCommand
            ])
            builder.insertSibling(saveMenu, afterMenu: .close)
        }

        let recentsMenuDataSource = RecentsMenuDataSource()
        builder.replace(menu: .openRecent, with: recentsMenuDataSource.recentsMenu)

        let helpMenuDataSource = HelpMenuDataSource()
        builder.insertChild(helpMenuDataSource.helpMenu, atStartOfMenu: .help)

        let preferencesMenu = UIMenu(title: Self.preferencesMenuTitle, identifier: .preferences, options: .displayInline, children: [
            UIKeyCommand(title: Self.preferencesMenuItemTitle, action: #selector(Self.displayPreferences), input: ",", modifierFlags: [.command])
        ])
        builder.insertSibling(preferencesMenu, afterMenu: .about)
    }

    private static let saveMenuItemTitle = NSLocalizedString("AppDelegate.saveMenuTitle", comment: "Save menu title")

    private static let preferencesMenuTitle = NSLocalizedString("AppDelegate.preferencesMenuTitle", comment: "Preferences menu title")
    private static let preferencesMenuItemTitle = NSLocalizedString("AppDelegate.preferencesMenuItemTitle", comment: "Preferences menu item title")
    @objc private func displayPreferences() {
        let activity = NSUserActivity(activityType: "com.cocoatype.Highlighter.settings")
        let existingScene = UIApplication.shared.openSessions.first(where: { $0.configuration.delegateClass == DesktopSettingsSceneDelegate.self })
        UIApplication.shared.requestSceneSessionActivation(existingScene, userActivity: activity, options: nil, errorHandler: nil)
    }
    #endif

    // MARK: Intent Handling

    func application(_ application: UIApplication, handlerFor intent: INIntent) -> Any? {
        guard #available(iOS 14.0, *) else { return nil }
        let intentHandler = IntentHandler()
        return intentHandler
    }

    // MARK: Boilerplate
    private var appViewController: AppViewController? { return window?.rootViewController as? AppViewController }
}
