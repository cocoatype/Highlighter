//  Created by Geoff Pado on 8/3/20.
//  Copyright © 2020 Cocoatype, LLC. All rights reserved.

import Editing
import ErrorHandling
import UIKit

#if targetEnvironment(macCatalyst)
class DesktopViewController: UIViewController, FileURLProvider {
    var editingViewController: PhotoEditingViewController? { children.first as? PhotoEditingViewController }

    init(representedURL: URL?, image: UIImage?, redactions: [Redaction]?) {
        self.initialRedactions = redactions
        self.representedURL = representedURL
        self.image = image
        super.init(nibName: nil, bundle: nil)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if children.contains(where: { $0 is PhotoEditingViewController }), let representedURL = representedURL {
            windowScene?.titlebar?.representedURL = representedURL
            windowScene?.title = representedURL.lastPathComponent
        } else if representedURL != nil {
            do {
                try loadRepresentedURL()
                updateURLRepresentation()
            } catch { ErrorHandling.log(error) }
        } else if image != nil {
            loadImage()
        }
    }

    // MARK: Represented URL

    var representedURL: URL? {
        didSet {
            do {
                try loadRepresentedURL()
                updateURLRepresentation()
            } catch {
                ErrorHandling.log(error)
            }
        }
    }

    private func loadRepresentedURL() throws {
        guard let representedURL = representedURL, image == nil else { return }
        let accessGranted = representedURL.startAccessingSecurityScopedResource()
        defer { representedURL.stopAccessingSecurityScopedResource() }
        guard accessGranted else { throw LoadError.accessNotGranted }

        let data = try Data(contentsOf: representedURL)
        guard let image = UIImage(data: data) else { return }
        self.image = image
    }

    private func updateURLRepresentation() {
        guard let representedURL = representedURL else {
            return
        }

        RecentsMenuDataSource.addRecentItem(representedURL)

        windowScene?.titlebar?.representedURL = representedURL
        windowScene?.title = representedURL.lastPathComponent
    }

    var representedFileURL: URL? { representedURL }

    func updateRepresentedFileURL(to newURL: URL) {
        representedURL = newURL
    }

    private func validateAllToolbarItems() {
        windowScene?.titlebar?.toolbar?.visibleItems?.forEach { $0.validate() }
    }

    // MARK: Image

    var image: UIImage? {
        didSet {
            loadImage()
        }
    }

    private func loadImage() {
        embed(PhotoEditingViewController(image: image, redactions: initialRedactions))
        validateAllToolbarItems()
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

    private enum LoadError: Error {
        case accessNotGranted
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
