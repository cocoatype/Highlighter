//  Created by Geoff Pado on 8/3/20.
//  Copyright © 2020 Cocoatype, LLC. All rights reserved.

import Editing
import UIKit

#if targetEnvironment(macCatalyst)
class DesktopViewController: UIViewController, UIDocumentPickerDelegate {
    var editingViewController: PhotoEditingViewController? { children.first as? PhotoEditingViewController }

    init(representedURL: URL?) {
        self.representedURL = representedURL
        super.init(nibName: nil, bundle: nil)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        guard children.contains(where: { $0 is PhotoEditingViewController }) == false else { return }
        guard representedURL == nil else { return loadRepresentedURL() }
        displayDocumentPicker()
    }

    // MARK: Represented URL

    var representedURL: URL? {
        didSet {
            loadRepresentedURL()
        }
    }

    private func loadRepresentedURL() {
        guard let representedURL = representedURL else { return }
        let accessGranted = representedURL.startAccessingSecurityScopedResource()
        defer { representedURL.stopAccessingSecurityScopedResource() }
        guard accessGranted else { return }

        do {
            let data = try Data(contentsOf: representedURL)
            guard let image = UIImage(data: data) else { return }

            RecentsMenuDataSource.addRecentItem(representedURL)

            if presentedViewController is UIDocumentPickerViewController {
                dismiss(animated: false, completion: nil)
            }

            windowScene?.titlebar?.representedURL = representedURL
            windowScene?.title = representedURL.lastPathComponent

            embed(PhotoEditingViewController(image: image))
            validateAllToolbarItems()
        } catch let error {
            dump(error)
            return
        }
    }

    // MARK: Document Picker

    private func displayDocumentPicker() {
        let pickerController = UIDocumentPickerViewController(forOpeningContentTypes: [.image])
        pickerController.delegate = self
        present(pickerController, animated: true, completion: nil)
    }

    private func validateAllToolbarItems() {
        windowScene?.titlebar?.toolbar?.visibleItems?.forEach { $0.validate() }
    }

    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let documentURL = urls.first else { return }
        representedURL = documentURL

        loadRepresentedURL()
    }

    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        guard let session = windowScene?.session, representedURL == nil else { return }
        UIApplication.shared.requestSceneSessionDestruction(session, options: nil)
    }

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
