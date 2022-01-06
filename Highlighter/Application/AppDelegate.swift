//  Created by Geoff Pado on 3/31/19.
//  Copyright © 2019 Cocoatype, LLC. All rights reserved.

import Editing
import ErrorHandling
import Intents
import Sentry
import UniformTypeIdentifiers
import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        ErrorHandling.setup()

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
        switch command.action {
        case #selector(clearRecents):
            validateClearRecents(command)
        case #selector(newSceneFromClipboard):
            validateNewSceneFromClipboard(command)
        default:
            super.validate(command)
        }
    }

    private func validateClearRecents(_ command: UICommand) {
        if Defaults.recentBookmarks.count == 0 {
            command.attributes = [.disabled]
        } else {
            command.attributes = []
        }
    }

    private func validateNewSceneFromClipboard(_ command: UICommand) {
        if UIPasteboard.general.contains(pasteboardTypes: [UTType.image.identifier]) {
            command.attributes = []
        } else {
            command.attributes = [.disabled]
        }
    }

    // MARK: Menu

    override func buildMenu(with builder: UIMenuBuilder) {
        guard builder.system == .main else { return }

        builder.replaceChildren(ofMenu: .close) { existingChildren in
            existingChildren + [
                UIKeyCommand(title: Self.saveMenuItemTitle, action: #selector(PhotoEditingViewController.save(_:)), input: "S", modifierFlags: [.command]),
                UIKeyCommand(title: Self.saveAsMenuItemTitle, action: #selector(PhotoEditingViewController.saveAs(_:)), input: "S", modifierFlags: [.command, .shift])
            ]
        }

        #if targetEnvironment(macCatalyst)
        if FeatureFlag.newFromClipboard {
            builder.replaceChildren(ofMenu: .newScene) {
                $0 + [NewFromClipboardCommand()]
            }
        }
        #endif

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
    private static let saveAsMenuItemTitle = NSLocalizedString("AppDelegate.saveAsMenuTitle", comment: "Save As menu title")

    private static let preferencesMenuTitle = NSLocalizedString("AppDelegate.preferencesMenuTitle", comment: "Preferences menu title")
    private static let preferencesMenuItemTitle = NSLocalizedString("AppDelegate.preferencesMenuItemTitle", comment: "Preferences menu item title")
    @objc private func displayPreferences() {
        let activity = NSUserActivity(activityType: "com.cocoatype.Highlighter.settings")
        let existingScene = UIApplication.shared.openSessions.first(where: { $0.configuration.delegateClass == DesktopSettingsSceneDelegate.self })
        UIApplication.shared.requestSceneSessionActivation(existingScene, userActivity: activity, options: nil, errorHandler: nil)
    }

    @objc func newSceneFromClipboard() {
        guard let data = UIPasteboard.general.data(forPasteboardType: UTType.image.identifier) else { return }
        let activity = EditingUserActivity(imageData: data)
        activity.needsSave = true
        UIApplication.shared.requestSceneSessionActivation(nil, userActivity: activity, options: nil, errorHandler: nil)
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
