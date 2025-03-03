//  Created by Geoff Pado on 4/1/19.
//  Copyright © 2019 Cocoatype, LLC. All rights reserved.

import AppNavigation
import Logging
import PhotoPermissions
import PhotoPicker
import PhotosUI
import SettingsUI
import SwiftUI
import UIKit

public class IntroViewController: UIHostingController<IntroView>, PhotoPickerDelegate {
    public init(
        logger: any Logger = TelemetryLogger(),
        permissionsRequester: any PhotoPermissionsRequester = PhotoLibraryPermissionsRequester()
    ) {
        self.logger = logger
        self.permissionsRequester = permissionsRequester
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
        func showPhotoLibrary()
    }

    // MARK: Boilerplate

    private let logger: any Logger
    private let permissionsRequester: PhotoPermissionsRequester

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
