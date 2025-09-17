//  Created by Geoff Pado on 8/3/20.
//  Copyright © 2020 Cocoatype, LLC. All rights reserved.

import UIKit

import FactoryKit

import AppRatings
import Defaults
import Editing
import Redactions
import Scenes
import Tools
import UserActivities

#if targetEnvironment(macCatalyst)
class DesktopSceneDelegate: NSObject, UIWindowSceneDelegate, NSToolbarDelegate, ShareItemDelegate,
                            ToolPickerItemDelegate, ColorPickerItemDelegate, SeekItemDelegate, ZoomItemDelegate {
    var window: DesktopAppWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene),
              let dependencies = SceneDependencyWrangler().dependencies(from: session, options: connectionOptions)
        else { return }

        let window = DesktopAppWindow(windowScene: scene, dependencies: dependencies)
        window.makeKeyAndVisible()

        let toolbar = NSToolbar()
        toolbar.delegate = self
        toolbar.displayMode = .iconOnly
        scene.titlebar?.toolbar = toolbar
        scene.titlebar?.toolbarStyle = .unified

        self.window = window
    }

    func scene(_ scene: UIScene, continue userActivity: NSUserActivity) {
        UIApplication.shared.requestSceneSessionActivation(nil, userActivity: userActivity, options: nil, errorHandler: nil)
    }

    func stateRestorationActivity(for scene: UIScene) -> NSUserActivity? {
        window?.stateRestorationActivity
    }

    private let urlHandler = DesktopSceneURLHandler()
    func scene(_ scene: UIScene, openURLContexts urlContexts: Set<UIOpenURLContext>) {
        for context in urlContexts {
            urlHandler.handle(context)
        }
    }

    func validateToolbarItems() {
        window?.windowScene?.titlebar?.toolbar?.visibleItems?.forEach { $0.validate() }
    }

    // MARK: ShareItemDelegate

    var canExportImage: Bool { return editingViewController != nil }

    func exportedURL() async throws -> URL? {
        return try await editingViewController?.preparedURL
    }

    @Injected(\.defaults) private var defaults
    func didExportImage() {
        defaults.set(defaults.value(for: Keys.numberOfSaves) + 1, for: Keys.numberOfSaves)
        Task { [weak self] in
            await AppRatingsPrompter().displayRatingsPrompt(in: self?.window?.windowScene)
        }
    }

    // MARK: ToolPickerItemDelegate

    var highlighterTool: HighlighterTool { return editingViewController?.highlighterTool ?? .magic }

    // MARK: ColorPickerItemDelegate

    var currentColor: UIColor { return .black }

    @objc func displayColorPicker(_ sender: NSToolbarItem) {
        editingViewController?.showColorPicker(self)
    }

    // MARK: SeekItemDelegate

    func toggleSeeking(_ sender: NSToolbarItem) {
        editingViewController?.toggleSeeking(sender)
    }

    // MARK: ZoomItemDelegate

    func zoomIn(_ sender: NSToolbarItem) {
        guard let editingViewController else { return }
        let currentScale = editingViewController.zoomScale
        editingViewController.zoomScale = ZoomItemGroup.zoomStops.first(where: {
            $0 > currentScale
        }) ?? ZoomItemGroup.zoomStops.last ?? currentScale
        print("zoom scale is \(editingViewController.zoomScale)")
    }

    func zoomOut(_ sender: NSToolbarItem) {
        guard let editingViewController else { return }
        let currentScale = editingViewController.zoomScale
        editingViewController.zoomScale = ZoomItemGroup.zoomStops.reversed().first(where: {
            $0 < currentScale
        }) ?? ZoomItemGroup.zoomStops.first ?? currentScale
        print("zoom scale is \(editingViewController.zoomScale)")
    }

    // MARK: NSToolbarDelegate

    func toolbarDefaultItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
        [
            ZoomItemGroup.identifier,
            SeekItem.identifier,
            ColorPickerItem.identifier,
            ToolPickerItem.identifier,
            ShareItem.identifier,
        ]
    }

    func toolbarAllowedItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
        return toolbarDefaultItemIdentifiers(toolbar)
    }

    func toolbar(_ toolbar: NSToolbar, itemForItemIdentifier itemIdentifier: NSToolbarItem.Identifier, willBeInsertedIntoToolbar flag: Bool) -> NSToolbarItem? {
        switch itemIdentifier {
        case ToolPickerItem.identifier: return ToolPickerItem(delegate: self)
        case ShareItem.identifier: return ShareItem(delegate: self)
        case ColorPickerItem.identifier: return ColorPickerItem(delegate: self)
        case SeekItem.identifier: return SeekItem(delegate: self)
        case ZoomInItem.identifier: return ZoomInItem(delegate: self)
        case ZoomOutItem.identifier: return ZoomOutItem(delegate: self)
        case ZoomItemGroup.identifier: return ZoomItemGroup(delegate: self)
        default: return nil
        }
    }

    // MARK: Boilerplate

    private var desktopViewController: DesktopViewController? { window?.rootViewController as? DesktopViewController }
    private var editingViewController: PhotoEditingViewController? { desktopViewController?.editingViewController }
}
#endif
