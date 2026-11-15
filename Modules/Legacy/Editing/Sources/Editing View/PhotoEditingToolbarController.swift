//  Created by Geoff Pado on 11/14/26.
//  Copyright © 2026 Cocoatype, LLC. All rights reserved.

import Photos
import UIKit

import Defaults
import EditingToolbar

/// Keeps the editing view controller's navigation bar and toolbar items up
/// to date as the editing state and settings change.
final class PhotoEditingToolbarController: PhotoEditingChainedResponder {
    init(photoEditingView: PhotoEditingScrollView, asset: PHAsset?) {
        self.photoEditingView = photoEditingView
        self.asset = asset
        super.init()

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(updateToolbarItemsForChange),
            name: PhotoEditingRedactionView.redactionsDidChange,
            object: nil
        )

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(updateToolbarItemsForChange),
            for: Keys.hideAutoRedactions
        )
    }

    @objc private func updateToolbarItemsForChange() {
        updateToolbarItems()
    }

    @objc func refreshToolbarItems() { updateToolbarItems() }

    func updateToolbarItems(animated: Bool = true) {
        guard let editingViewController else { return }

        // the action set resolves targets starting from the head of the editing chain
        let actionSet = ActionSet(
            for: editingViewController,
            undoManager: editingViewController.undoManager,
            selectedTool: photoEditingView.highlighterTool,
            sizeClass: editingViewController.traitCollection.horizontalSizeClass,
            currentColor: photoEditingView.color,
            asset: asset
        )

        let navigationItem = editingViewController.navigationItem
        if #available(iOS 16, *) {
            navigationItem.style = .editor

            navigationItem.leadingItemGroups = actionSet.leadingNavigationItems.map { $0.creatingFixedGroup() }
            navigationItem.centerItemGroups = actionSet.centerNavigationItems.map { $0.creatingFixedGroup() }
            navigationItem.trailingItemGroups = actionSet.trailingNavigationItems.map { $0.creatingFixedGroup() }
        } else {
            navigationItem.setLeftBarButtonItems(actionSet.leadingNavigationItems, animated: false)
            navigationItem.setRightBarButtonItems(actionSet.trailingNavigationItems, animated: false)
        }

        editingViewController.setToolbarItems(actionSet.toolbarItems, animated: animated)
        editingViewController.navigationController?.setToolbarHidden(actionSet.toolbarItems.count == 0, animated: animated)

        editingViewController.userActivity?.needsSave = true
    }

    // MARK: Boilerplate

    private let photoEditingView: PhotoEditingScrollView
    private let asset: PHAsset?
}
