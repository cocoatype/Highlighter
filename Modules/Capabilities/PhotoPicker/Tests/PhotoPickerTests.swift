//  Created by Geoff Pado on 3/3/25.
//  Copyright © 2025 Cocoatype, LLC. All rights reserved.

import PhotosUI
import Testing
import UIKit

@testable import PhotoPicker

@MainActor
struct PhotoPickerTests {
    @Test
    func pickerViewController() {
        let picker = PhotoPicker()
        let pickerViewController = picker.pickerViewController

        #expect(pickerViewController.configuration.selectionLimit == 1)
        #expect(pickerViewController.configuration.filter == .images)
        #expect(pickerViewController.overrideUserInterfaceStyle == .dark)
        #expect(pickerViewController.delegate === picker)
    }

    @Test
    func didFinishPickingWithNoResults() async {
        class StubDelegate: PhotoPickerDelegate {
            private let confirmation: Confirmation
            init(confirmation: Confirmation) {
                self.confirmation = confirmation
            }

            func picker(_ picker: PhotoPicker, didSelectImage image: UIImage?) {
                #expect(image == nil)
                confirmation()
            }
        }

        await confirmation { confirmation in
            let picker = PhotoPicker()
            let delegate = StubDelegate(confirmation: confirmation)
            picker.delegate = delegate
            picker.picker(picker.pickerViewController, didFinishPicking: [])
        }
    }
}
