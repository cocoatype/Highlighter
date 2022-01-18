//  Created by Geoff Pado on 2/25/21.
//  Copyright © 2021 Cocoatype, LLC. All rights reserved.

import Editing
import UIKit

#if targetEnvironment(macCatalyst)
class DesktopAppWindow: UIWindow, UIDocumentBrowserViewControllerDelegate {
    init(windowScene: UIWindowScene, representedURL: URL?, image: UIImage?, redactions: [Redaction]?) {
        desktopViewController = DesktopViewController(representedURL: representedURL, image: image, redactions: redactions)
        super.init(windowScene: windowScene)

        isOpaque = false

        if representedURL == nil && image == nil {
            let documentBrowser = DesktopDocumentBrowserViewController()
            documentBrowser.delegate = self
            rootViewController = documentBrowser
        } else {
            rootViewController = desktopViewController
        }
    }

    var stateRestorationActivity: NSUserActivity? {
        desktopViewController.stateRestorationActivity
    }

    // MARK: Document Browser Delegate

    func documentBrowser(_ controller: UIDocumentBrowserViewController, didPickDocumentsAt documentURLs: [URL]) {
        desktopViewController.representedURL = documentURLs.first
        rootViewController = desktopViewController
    }

    // MARK: Boilerplate

    let desktopViewController: DesktopViewController

    @available(*, unavailable)
    required init(coder: NSCoder) {
        let className = String(describing: type(of: self))
        fatalError("\(className) does not implement init(coder:)")
    }
}

class DesktopDocumentBrowserViewController: UIDocumentBrowserViewController, UIDocumentBrowserViewControllerDelegate {
    init() {
        super.init(forOpening: [.image])

        allowsDocumentCreation = false
        delegate = self
    }

    // MARK: Boilerplate

    @available(*, unavailable)
    required init(coder: NSCoder) {
        fatalError("\(String(describing: type(of: Self.self))) does not implement init(coder:)")
    }
}
#endif
