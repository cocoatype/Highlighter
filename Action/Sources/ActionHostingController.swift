//  Created by Geoff Pado on 7/1/19.
//  Copyright © 2019 Cocoatype, LLC. All rights reserved.

import MobileCoreServices
import SwiftUI
import UIKit

import FactoryKit

import Editing
import ErrorHandling

class ActionHostingController: UIHostingController<ActionView> {
    init() {
        super.init(rootView: ActionView())
    }

    override func loadView() {
        view = UIView()
        view.backgroundColor = .clear
        view.isOpaque = false
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loadImageFromExtensionContext()
    }

    private func loadImageFromExtensionContext() {
        print(#function)
        let imageTypeIdentifier = (kUTTypeImage as String)

        let imageProvider = extensionContext?
            .inputItems
            .compactMap { $0 as? NSExtensionItem }
            .flatMap { $0.attachments ?? [] }
            .first(where: { $0.hasItemConformingToTypeIdentifier(imageTypeIdentifier) })

        imageProvider?.loadItem(forTypeIdentifier: imageTypeIdentifier, options: nil) { [weak self] item, error in
            do {
                guard let imageURL = (item as? URL) else { throw (error ?? ActionError.imageURLNotFound) }

                let imageData = try Data(contentsOf: imageURL)
                let imageDataString = imageData.base64EncodedString()
                guard let callbackURL = URL(string: "highlighter://x-callback-url/open?imageData=\(imageDataString)") else { throw ActionError.callbackURLConstructionFailed }
                self?.chain(selector: #selector(Self.openURL(_:)), object: callbackURL)
                self?.extensionContext?.completeRequest(returningItems: [], completionHandler: nil)
            } catch {
                Container.shared.errorHandler().log(error)
            }
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
