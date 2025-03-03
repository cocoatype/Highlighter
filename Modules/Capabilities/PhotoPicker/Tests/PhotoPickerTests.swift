//  Created by Geoff Pado on 3/3/25.
//  Copyright © 2025 Cocoatype, LLC. All rights reserved.

import Testing

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
}
