//  Created by Geoff Pado on 8/3/20.
//  Copyright © 2020 Cocoatype, LLC. All rights reserved.

import UIKit

#if targetEnvironment(macCatalyst)
class DesktopViewController: UIViewController, UIDocumentPickerDelegate {
    var editingViewController: PhotoEditingViewController? { children.first as? PhotoEditingViewController }

    init() {
        super.init(nibName: nil, bundle: nil)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let pickerController = UIDocumentPickerViewController(forOpeningContentTypes: [.image])
        pickerController.delegate = self
        present(pickerController, animated: true, completion: nil)
    }

    // MARK: UIDocumentPickerDelegate

    private func validateAllToolbarItems() {
        windowScene?.titlebar?.toolbar?.visibleItems?.forEach { $0.validate() }
    }

    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let documentURL = urls.first else { return }
        windowScene?.titlebar?.representedURL = documentURL
        windowScene?.title = documentURL.lastPathComponent

        guard let data = try? Data(contentsOf: documentURL),
              let image = UIImage(data: data)
        else { return }

        embed(PhotoEditingViewController(image: image))
        validateAllToolbarItems()
    }

    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {}

    // MARK: Boilerplate

    private var windowScene: UIWindowScene? { return view.window?.windowScene }

    @available(*, unavailable)
    required init(coder: NSCoder) {
        let typeName = NSStringFromClass(type(of: self))
        fatalError("\(typeName) does not implement init(coder:)")
    }
}

class DesktopView: UIView {
    init() {
        super.init(frame: .zero)
        backgroundColor = .primary
    }

    // MARK: Boilerplate

    @available(*, unavailable)
    required init(coder: NSCoder) {
        let typeName = NSStringFromClass(type(of: self))
        fatalError("\(typeName) does not implement init(coder:)")
    }
}
#endif
