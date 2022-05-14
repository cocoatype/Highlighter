//  Created by Geoff Pado on 10/16/20.
//  Copyright © 2020 Cocoatype, LLC. All rights reserved.

import PhotosUI

@available(iOS 14.0, *)
class PhotoPicker: NSObject, PHPickerViewControllerDelegate {
    weak var delegate: PhotoPickerDelegate?

    lazy var pickerViewController: PHPickerViewController = {
        var configuration = PHPickerConfiguration()
        configuration.selectionLimit = 1
        configuration.filter = .images

        let controller = PHPickerViewController(configuration: configuration)
        controller.overrideUserInterfaceStyle = .dark
        controller.delegate = self
        return controller
    }()

    // MARK: Delegate Methods

    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        guard let delegate = delegate else { return }
        guard let provider = results.first?.itemProvider else {
            return delegate.picker(self, didSelectImage: nil)
        }

        provider.loadObject(ofClass: UIImage.self) { [weak self] image, error in
            guard let picker = self else { return }
            delegate.picker(picker, didSelectImage: (image as? UIImage))
        }
    }
}

@available(iOS 14.0, *)
protocol PhotoPickerDelegate: AnyObject {
    func picker(_ picker: PhotoPicker, didSelectImage image: UIImage?)
}
