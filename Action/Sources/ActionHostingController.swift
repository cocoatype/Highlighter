//  Created by Geoff Pado on 7/1/19.
//  Copyright © 2019 Cocoatype, LLC. All rights reserved.

import UIKit
import UniformTypeIdentifiers

import FactoryKit

import Editing
import ErrorHandling

class ActionHostingController: UIViewController {
    init() {
        super.init(nibName: nil, bundle: nil)
    }

    deinit {
        loadTask?.cancel()
    }

    override func loadView() {
        view = UIView()
        view.backgroundColor = .clear
        view.isOpaque = false
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loadTask = Task {
            await loadImageFromExtensionContext()
        }
    }

    private var loadTask: Task<Void, Never>?
    private func loadImageFromExtensionContext() async {
        print(#function)
        let imageTypeIdentifier = UTType.image.identifier

        guard let imageProvider = extensionContext?
            .inputItems
            .compactMap({ $0 as? NSExtensionItem })
            .flatMap({ $0.attachments ?? [] })
            .first(where: { $0.hasItemConformingToTypeIdentifier(imageTypeIdentifier) })
        else { return }

        do {
            let item = try await imageProvider.loadItem(forTypeIdentifier: imageTypeIdentifier, options: nil)

            guard let imageURL = (item as? URL) else { throw ActionError.imageURLNotFound }

            let imageData = try Data(contentsOf: imageURL)
            let imageDataString = imageData.base64EncodedString()
            guard let callbackURL = URL(string: "highlighter://x-callback-url/open?imageData=\(imageDataString)") else { throw ActionError.callbackURLConstructionFailed }

            chain(selector: #selector(Self.openURL(_:)), object: callbackURL)
            extensionContext?.completeRequest(returningItems: [], completionHandler: nil)
        } catch {
            Container.shared.errorHandler()
                .log(error, module: "Action", type: "ActionHostingController")
        }
    }

    // just to provide the selector
    @objc private func openURL(_ url: URL) {}

    @available(*, unavailable)
    required init(coder: NSCoder) {
        let className = String(describing: type(of: self))
        fatalError("\(className) does not implement init(coder:)")
    }
}

enum ActionError: Error {
    case callbackURLConstructionFailed
    case imageURLNotFound
    case invalidImageData
}
