//  Created by Geoff Pado on 11/14/26.
//  Copyright © 2026 Cocoatype, LLC. All rights reserved.

import UIKit

import EditingToolbar

/// Presents the color picker (or the color panel on Mac) and applies the
/// chosen color to the editing view.
final class PhotoEditingColorPickerController: PhotoEditingChainedResponder, UIColorPickerViewControllerDelegate {
    init(photoEditingView: PhotoEditingScrollView) {
        self.photoEditingView = photoEditingView
        super.init()

        #if targetEnvironment(macCatalyst)
        ColorPanel.shared.color = .black
        colorObserver = NotificationCenter.default.addObserver(forName: ColorPanel.colorDidChangeNotification, object: nil, queue: .main, using: { [weak self] notification in
            guard let colorPanel = notification.object as? ColorPanel else { return }
            self?.photoEditingView.color = colorPanel.color
        })
        #endif
    }

    deinit {
        colorObserver.map(NotificationCenter.default.removeObserver)
    }

    // MARK: Actions

    @objc func toggleColorPicker(_ sender: Any) {
        guard let editingViewController else { return }
        if editingViewController.presentedViewController is ColorPickerViewController {
            editingViewController.dismiss(animated: true)
        } else {
            showColorPicker(sender)
        }
    }

    @objc func showColorPicker(_ sender: Any) {
        guard let editingViewController else { return }

        if editingViewController.traitCollection.userInterfaceIdiom == .mac {
            ColorPanel.shared.makeKeyAndOrderFront(sender)
        } else {
            let colorPickerItem: UIBarButtonItem
            if let barButtonItem = sender as? UIBarButtonItem {
                colorPickerItem = barButtonItem
            } else if let barButtonItem = editingViewController.findBarButtonItem({ $0 is ColorPickerBarButtonItem }) {
                colorPickerItem = barButtonItem
            } else { return }

            let picker = ColorPickerViewController()
            picker.delegate = self
            picker.popoverPresentationController?.barButtonItem = colorPickerItem
            editingViewController.present(picker, animated: true)
        }
    }

    @objc func selectedColorDidChange(_ sender: UIColorWell) {
        guard let color = sender.selectedColor else { return }
        photoEditingView.color = color
    }

    // MARK: UIColorPickerViewControllerDelegate

    func colorPickerViewControllerDidSelectColor(_ viewController: UIColorPickerViewController) {
        photoEditingView.color = viewController.selectedColor
        sendToEditor(#selector(PhotoEditingResponderActions.refreshToolbarItems))
    }

    // MARK: Boilerplate

    private let photoEditingView: PhotoEditingScrollView
    private var colorObserver: Any?
}
