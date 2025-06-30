//  Created by Geoff Pado on 7/5/24.
//  Copyright © 2024 Cocoatype, LLC. All rights reserved.

#if targetEnvironment(macCatalyst)
import UIKit

class DesktopSaveViewController: UIDocumentPickerViewController, UIDocumentPickerDelegate {
    private var onSave: (([URL]) -> Void)?
    convenience init(url: URL, onSave: @escaping (([URL]) -> Void)) {
        self.init(forExporting: [url], asCopy: true)
        self.onSave = onSave
        delegate = self
    }

    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let onSave = self.onSave else { return }
        DispatchQueue.main.async {
            onSave(urls)
        }
    }
}
#endif
