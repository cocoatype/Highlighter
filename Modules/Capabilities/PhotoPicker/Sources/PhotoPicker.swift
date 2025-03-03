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

    private let imageLoader = PhotoPickerResultImageLoader()
    public func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        guard let delegate = delegate else { return }
        guard let result = results.first else {
            return delegate.picker(self, didSelectImage: nil)
        }

        Task {
            await delegate.picker(self, didSelectImage: imageLoader.loadImage(for: result))
        }
    }
}

public protocol PhotoPickerDelegate: AnyObject {
    @MainActor func picker(_ picker: PhotoPicker, didSelectImage image: UIImage?)
}
