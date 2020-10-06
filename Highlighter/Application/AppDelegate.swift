//  Created by Geoff Pado on 3/31/19.
//  Copyright © 2019 Cocoatype, LLC. All rights reserved.

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

    // MARK: Menu

    #if targetEnvironment(macCatalyst)
    override func buildMenu(with builder: UIMenuBuilder) {
        guard builder.system == .main else { return }

        let saveMenu = UIMenu(title: "", options: [.displayInline], children: [
            UIKeyCommand(title: "Save", action: #selector(PhotoEditingViewController.save(_:)), input: "S", modifierFlags: [.command])
        ])
        builder.insertSibling(saveMenu, afterMenu: .close)

        let about = UICommand(title: Self.aboutMenuItemTitle, action: #selector(Self.displayAbout))
        let privacyPolicy = UICommand(title: Self.privacyMenuItemTitle, action: #selector(Self.displayPrivacyPolicy))
        let acknowledgements = UICommand(title: Self.acknowledgementsMenuItemTitle, action: #selector(Self.displayAcknowledgements))
        let contact = UICommand(title: Self.contactMenuItemTitle, action: #selector(Self.initiateContact))
        let helpMenu = UIMenu(title: "", image: nil, identifier: nil, options: .displayInline, children: [about, privacyPolicy, acknowledgements, contact])
        builder.insertChild(helpMenu, atStartOfMenu: .help)

        let preferencesMenu = UIMenu(title: "Preferences", identifier: .preferences, options: .displayInline, children: [
            UIKeyCommand(title: "Preferences…", action: #selector(Self.displayPreferences), input: ",", modifierFlags: [.command])
        ])
        builder.insertSibling(preferencesMenu, afterMenu: .about)
    }
    #endif

    @objc private func displayPreferences() {
        let activity = NSUserActivity(activityType: "com.cocoatype.Highlighter.settings")
        let existingScene = UIApplication.shared.openSessions.first(where: { $0.configuration.delegateClass == DesktopSettingsSceneDelegate.self })
        UIApplication.shared.requestSceneSessionActivation(existingScene, userActivity: activity, options: nil, errorHandler: nil)
    }

    private static let privacyMenuItemTitle = NSLocalizedString("SettingsContentProvider.Item.privacy", comment: "Privacy menu item title")
    @objc private func displayPrivacyPolicy() {
        UIApplication.shared.open(PrivacyViewController.url, options: [:], completionHandler: nil)
    }

    private static let aboutMenuItemTitle = NSLocalizedString("SettingsContentProvider.Item.about", comment: "About menu item title")
    @objc private func displayAbout() {
        UIApplication.shared.open(AboutViewController.url, options: [:], completionHandler: nil)
    }

    private static let acknowledgementsMenuItemTitle = NSLocalizedString("SettingsContentProvider.Item.acknowledgements", comment: "Acknowledgements menu item title")
    @objc private func displayAcknowledgements() {
        UIApplication.shared.open(AcknowledgementsViewController.url, options: [:], completionHandler: nil)
    }

    private static let contactMenuItemTitle = NSLocalizedString("SettingsContentProvider.Item.contact", comment: "Contact menu item title")
    @objc private func initiateContact() {
        UIApplication.shared.open(ContactMailViewController.mailtoURL, options: [:], completionHandler: nil)
    }

    // MARK: Boilerplate
    private var appViewController: AppViewController? { return window?.rootViewController as? AppViewController }
}
