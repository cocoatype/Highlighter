//  Created by Geoff Pado on 7/26/24.
//  Copyright © 2024 Cocoatype, LLC. All rights reserved.

import DesignSystem
import UIKit
import UserActivities

#if targetEnvironment(macCatalyst)
class DesktopOpenWindow: UIWindow {
    override init(windowScene: UIWindowScene) {
        super.init(windowScene: windowScene)

        let browserViewController = DesktopDocumentBrowserViewController()
        browserViewController.delegate = browserDelegate

        isHidden = true
        isOpaque = false
        rootViewController = browserViewController
    }

    @available(*, unavailable)
    required init(coder: NSCoder) {
        let typeName = NSStringFromClass(type(of: self))
        fatalError("\(typeName) does not implement init(coder:)")
    }

    private let browserDelegate = DesktopOpenBrowserDelegate()
}

class DesktopOpenBrowserDelegate: NSObject, UIDocumentBrowserViewControllerDelegate {
    func documentBrowser(_ controller: UIDocumentBrowserViewController, didPickDocumentsAt documentURLs: [URL]) {
        guard let documentURL = documentURLs.first else { return }
        let activity = LaunchActivity(documentURL)
        Task { @MainActor in
            UIApplication.shared.requestSceneSessionActivation(nil, userActivity: activity, options: nil, errorHandler: nil)
        }
    }
}
#endif
