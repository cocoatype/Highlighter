//  Created by Geoff Pado on 10/16/20.
//  Copyright © 2020 Cocoatype, LLC. All rights reserved.

import PhotosUI
import UniformTypeIdentifiers

@MainActor
public class PhotoPicker: NSObject, PHPickerViewControllerDelegate {
    public weak var delegate: PhotoPickerDelegate?

    public lazy var pickerViewController: PHPickerViewController = {
        var configuration = PHPickerConfiguration()
        configuration.selectionLimit = 1
        configuration.filter = .images

        let controller = PHPickerViewController(configuration: configuration)
        controller.overrideUserInterfaceStyle = .dark
        controller.delegate = self
        return controller
    }()

    // MARK: Delegate Methods

    public func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        guard let delegate = delegate else { return }
        guard let provider = results.first?.itemProvider else {
            return delegate.picker(self, didSelectImage: nil)
        }

        provider.loadObject(ofClass: UIImage.self) { [weak self] loadedObject, _ in
            guard let image = loadedObject as? UIImage else { return }
            Task { [weak self] in
                await MainActor.run { [weak self] in
                    guard let picker = self, let delegate = picker.delegate else { return }
                    delegate.picker(picker, didSelectImage: image)
                }
            }
        }
    }
}

public protocol PhotoPickerDelegate: AnyObject {
    @MainActor func picker(_ picker: PhotoPicker, didSelectImage image: UIImage?)
}
