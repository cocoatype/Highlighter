//  Created by Geoff Pado on 8/3/20.
//  Copyright © 2020 Cocoatype, LLC. All rights reserved.

import Editing
import ErrorHandling
import UIKit

#if targetEnvironment(macCatalyst)
class DesktopViewController: UIViewController, FileURLProvider {
    var editingViewController: PhotoEditingViewController? { children.first as? PhotoEditingViewController }

    init(representedURL: URL?, redactions: [Redaction]?) {
        self.initialRedactions = redactions
        self.representedURL = representedURL
        super.init(nibName: nil, bundle: nil)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if children.contains(where: { $0 is PhotoEditingViewController }), let representedURL = representedURL {
            windowScene?.titlebar?.representedURL = representedURL
            windowScene?.title = representedURL.lastPathComponent
        } else {
            loadRepresentedURL()
        }
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

            windowScene?.titlebar?.representedURL = representedURL
            windowScene?.title = representedURL.lastPathComponent

            embed(PhotoEditingViewController(image: image, redactions: initialRedactions))
            validateAllToolbarItems()
        } catch let error {
            dump(error)
            return
        }
    }

    var representedFileURL: URL? { representedURL }

    private func validateAllToolbarItems() {
        windowScene?.titlebar?.toolbar?.visibleItems?.forEach { $0.validate() }
    }

    // MARK: State Restoration

    var stateRestorationActivity: NSUserActivity? {
        editingViewController?.userActivity
    }

    // MARK: Boilerplate

    private let initialRedactions: [Redaction]?
    private var windowScene: UIWindowScene? { return view.window?.windowScene }

    @available(*, unavailable)
    required init(coder: NSCoder) {
        ErrorHandling.notImplemented()
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
        ErrorHandling.notImplemented()
    }
}
#endif
