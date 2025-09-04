//  Created by Geoff Pado on 8/3/20.
//  Copyright © 2020 Cocoatype, LLC. All rights reserved.

import Photos
import UIKit

import FactoryKit

import Defaults
import Editing
import ErrorHandling
import PhotoAssets
import Redactions
import Scenes

#if targetEnvironment(macCatalyst)
class DesktopViewController: UIViewController, FileURLProvider {
    var editingViewController: PhotoEditingViewController? { children.first as? PhotoEditingViewController }

    @Injected(\.defaults) private var defaults
    @Injected(\.errorHandler) private var errorHandler
    init(
        dependencies: SceneDependencies
    ) {
        self.assetLocalIdentifier = dependencies.assetLocalIdentifier
        self.assetCloudIdentifier = dependencies.assetCloudIdentifier
        self.initialRedactions = dependencies.redactions
        self.representedURL = dependencies.representedURL
        self.image = dependencies.image
        super.init(nibName: nil, bundle: nil)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        updateWindowURL()

        if image != nil {
            loadImage()
        } else if assetLocalIdentifier != nil || assetCloudIdentifier != nil {
            loadAsset()
        }
    }

    // MARK: Represented URL

    var representedURL: URL? {
        didSet {
            updateWindowURL()
        }
    }

    private func updateWindowURL() {
        if let windowURL {
            if editingViewController == nil {
                RecentsMenuDataSource.addRecentItem(windowURL, defaults: defaults)
            }

            windowScene?.titlebar?.representedURL = windowURL
            windowScene?.title = windowURL.lastPathComponent
        } else {
            // reset to nil
        }
    }

    private var windowURL: URL? {
        guard let representedURL,
              FileManager.default.fileExists(atPath: representedURL.path)
        else { return nil }

        do {
            let cachesDirectory = try FileManager.default.url(
                for: .cachesDirectory,
                in: .userDomainMask,
                appropriateFor: nil,
                create: false
            )

            guard cachesDirectory.isParent(of: representedURL) == false else { return nil }

            return representedURL
        } catch {
            errorHandler.log(error, module: "Core", type: "DesktopViewController")
            return nil
        }
    }

    var representedFileURL: URL? { representedURL }

    func updateRepresentedFileURL(to newURL: URL) {
        representedURL = newURL
    }

    private func validateAllToolbarItems() {
        windowScene?.titlebar?.toolbar?.visibleItems?.forEach { $0.validate() }
    }

    // MARK: Asset

    private var assetLocalIdentifier: String?
    private var assetCloudIdentifier: String?

    private let retriever = PhotoAssetsRetriever()
    private func loadAsset() {
        guard let asset = retriever.asset(forLocalIdentifier: assetLocalIdentifier, cloudIdentifier: assetCloudIdentifier)
        else { return }

        embed(PhotoEditingViewController(asset: asset, redactions: initialRedactions))
        validateAllToolbarItems()
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

    @available(*, unavailable)
    required init(coder: NSCoder) {
        Container.shared.errorHandler().notImplemented()
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
        Container.shared.errorHandler().notImplemented()
    }
}
#endif
