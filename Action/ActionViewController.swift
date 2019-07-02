//  Created by Geoff Pado on 6/26/19.
//  Copyright © 2019 Cocoatype, LLC. All rights reserved.

import MobileCoreServices
import UIKit

class ActionViewController: BasePhotoEditingViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

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

    @IBAction func done() {
        // Return any edited content to the host app.
        // This template doesn't do anything, so we just echo the passed in items.
        self.extensionContext!.completeRequest(returningItems: self.extensionContext!.inputItems, completionHandler: nil)
    }
}

enum ActionError: Error {
    case imageURLNotFound
    case invalidImageData
}
