//  Created by Geoff Pado on 6/26/19.
//  Copyright © 2019 Cocoatype, LLC. All rights reserved.

import MobileCoreServices
import UIKit

class ActionEditingViewController: BasePhotoEditingViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        loadImageFromExtensionContext()

        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(ActionEditingViewController.done))
    }

    private func loadImageFromExtensionContext() {
        let imageTypeIdentifier = (kUTTypeImage as String)

        let imageProvider = extensionContext?
            .inputItems
            .compactMap { $0 as? NSExtensionItem }
            .flatMap { $0.attachments ?? [] }
            .first(where: { $0.hasItemConformingToTypeIdentifier(imageTypeIdentifier) })

        imageProvider?.loadItem(forTypeIdentifier: imageTypeIdentifier, options: nil) { [weak self] item, error in
            do {
                guard let imageURL = (item as? URL) else { throw (error ?? ActionError.imageURLNotFound)  }

                let imageData = try Data(contentsOf: imageURL)
                guard let image = UIImage(data: imageData) else { throw ActionError.invalidImageData }

                DispatchQueue.main.async { [weak self] in
                    self?.load(image)
                }
            } catch {
                dump(error)
            }
        }
    }

    @objc private func done() {
        let items: [Any]
        if let imageForExport = imageForExport {
            let extensionItem = NSExtensionItem()
            let itemProvider = NSItemProvider(item: imageForExport, typeIdentifier: (kUTTypeImage as String))
            extensionItem.attachments = [itemProvider]
            items = [extensionItem]
        } else {
            items = []
        }

        self.extensionContext?.completeRequest(returningItems: items, completionHandler: nil)
    }
}

enum ActionError: Error {
    case imageURLNotFound
    case invalidImageData
}
