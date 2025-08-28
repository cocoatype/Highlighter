//  Created by Geoff Pado on 4/1/19.
//  Copyright © 2019 Cocoatype, LLC. All rights reserved.

import PhotosUI
import SwiftUI
import UIKit

import FactoryKit

import AppNavigation
import Logging
import MobileSettingsUI
import PhotoPermissions
import PhotoPicker

public class IntroViewController: UIHostingController<IntroView>, PhotoPickerDelegate {
    public init() {
        super.init(rootView: IntroView())
        self.rootView = IntroView(
            permissionAction: { [weak self] in
                Task { [weak self] in
                    await self?.requestPermission()
                }
            },
            importAction: importPhoto
        )

        navigationItem.rightBarButtonItem = SettingsBarButtonItem.standard
    }

    public override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        view.backgroundColor = .primary
    }

    func requestPermission() async {
        let status = await permissionsRequester.requestAuthorization()
        switch status {
        case .authorized, .limited:
            UIApplication.shared.sendAction(#selector(Actions.showPhotoLibrary), to: nil, from: self, for: nil)
        case .restricted:
            present(PhotoPermissionsRestrictedAlertFactory().alert(), animated: true)
        case .denied:
            present(PhotoPermissionsDeniedAlertFactory().alert(), animated: true)
        case .notDetermined:
            fallthrough
        @unknown default:
            break
        }
    }

    func importPhoto() {
        present(photoPicker.pickerViewController, animated: true)
    }

    // MARK: PhotoPickerDelegate

    public func picker(_ picker: PhotoPicker, didSelectImage image: UIImage?) {
        dismiss(animated: true)

        guard let image else { return }
        logger.log(EventFactory().editorPresentationEvent(for: .photoPicker))
        photoEditorPresenter?.presentPhotoEditingViewController(for: image, redactions: nil, animated: true, completionHandler: nil)
    }

    // MARK: Actions

    @objc public protocol Actions {
        @MainActor func showPhotoLibrary()
    }

    // MARK: Boilerplate

    @Injected(\.logger) private var logger
    @Injected(\.photoPermissionsRequester) private var permissionsRequester

    private lazy var photoPicker: PhotoPicker = {
        let picker = PhotoPicker()
        picker.delegate = self
        return picker
    }()

    @available(*, unavailable)
    required init(coder: NSCoder) {
        let className = String(describing: type(of: self))
        fatalError("\(className) does not implement init(coder:)")
    }
}
