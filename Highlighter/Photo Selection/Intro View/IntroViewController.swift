//  Created by Geoff Pado on 4/1/19.
//  Copyright © 2019 Cocoatype, LLC. All rights reserved.

import PhotosUI
import SwiftUI
import UIKit

class IntroViewController: UIHostingController<IntroView>, PhotoPickerDelegate {
    init(permissionsRequester: PhotoPermissionsRequester = PhotoPermissionsRequester()) {
        self.permissionsRequester = permissionsRequester
        super.init(rootView: IntroView())

        let introView: IntroView
        if #available(iOS 14.0, *) {
            introView = IntroView(permissionAction: requestPermission, importAction: importPhoto)
        } else {
            introView = IntroView(permissionAction: requestPermission)
        }

        self.rootView = introView
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        view.backgroundColor = .primary
    }

    @objc func requestPermission() {
        permissionsRequester.requestAuthorization { [weak self] status in
            switch status {
            case .authorized, .limited:
                UIApplication.shared.sendAction(#selector(AppViewController.showPhotoLibrary), to: nil, from: self, for: nil)
            case .restricted:
                self?.present(PhotoPermissionsRestrictedAlertFactory.alert(), animated: true)
            case .denied:
                self?.present(PhotoPermissionsDeniedAlertFactory.alert(), animated: true)
            case .notDetermined:
                fallthrough
            @unknown default:
                break
            }
        }
    }

    @available(iOS 14.0, *)
    @objc func importPhoto() {
        present(photoPicker.pickerViewController, animated: true)
    }

    // MARK: PhotoPickerDelegate

    @available(iOS 14.0, *)
    func picker(_ picker: PhotoPicker, didSelectImage image: UIImage?) {
        DispatchQueue.main.async { [weak self] in
            self?.dismiss(animated: true)

            guard let image = image else { return }
            self?.photoEditorPresenter?.presentPhotoEditingViewController(for: image, redactions: nil, animated: true, completionHandler: nil)
        }
    }

    // MARK: Boilerplate

    private let permissionsRequester: PhotoPermissionsRequester

    @available(iOS 14.0, *)
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
