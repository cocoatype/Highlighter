//  Created by Geoff Pado on 3/31/19.
//  Copyright © 2019 Cocoatype, LLC. All rights reserved.

import Defaults
import DesignSystem
import Editing
import ErrorHandling
import Logging
import Intents
import Purchasing
import Scenes
import UniformTypeIdentifiers
import UIKit
import UserActivities

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    override convenience init() {
        self.init(
            defaults: Defaults.provider,
            purchaseRepository: Purchasing.repository,
            logger: Logging.logger,
            appearanceWriter: DesignSystem.appearanceWriter
        )
    }

    init(
        defaults: any DefaultsProvider,
        purchaseRepository: any PurchaseRepository,
        logger: Logger,
        appearanceWriter: any AppearanceWriter
    ) {
        self.defaults = defaults
        veryGoodText = purchaseRepository
        self.logger = logger
        self.appearanceWriter = appearanceWriter
        super.init()
    }

    func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        veryGoodText.start()
        Defaults.performMigrations()

        #if targetEnvironment(macCatalyst)
        UserDefaults.standard.set(true, forKey: "NSQuitAlwaysKeepsWindows")
        #endif

        appearanceWriter.overwriteAppearance()

        return true
    }

    func application(_ application: UIApplication, configurationForConnecting session: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return SceneProvider().sceneConfiguration(session: session, options: options)
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
        RecentsMenuDataSource.clearRecentItems(defaults: defaults)
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
        let recentBookmarks = defaults.value(for: Keys.recentBookmarks) ?? []
        command.attributes = if recentBookmarks.count == 0 {
            [.disabled]
        } else {
            []
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
        MenuBuilder.buildMenu(with: builder)
    }

    @objc func displayPreferences() {
        let activity = DesktopSettingsActivity()
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

    // MARK: Boilerplate
    private var appViewController: AppViewController? { return window?.rootViewController as? AppViewController }

    // veryGoodText by @NoGoodNick_ on 2024-05-15
    // the purchase repository
    private let veryGoodText: any PurchaseRepository
    private let defaults: any DefaultsProvider
    private let logger: any Logger
    private let appearanceWriter: any AppearanceWriter
}
