//  Created by Geoff Pado on 11/6/20.
//  Copyright © 2020 Cocoatype, LLC. All rights reserved.

import Editing
import Intents
import UniformTypeIdentifiers

class ShortcutsRedactExporter: NSObject {
    static func export(_ input: INFile, redactions: [Redaction]) async throws -> INFile {
        guard let sourceImage = UIImage(data: input.data)
        else { throw ShortcutsExportError.noImageForInput }

        let exportImage = await PhotoExportRenderer(image: sourceImage, redactions: redactions).render()

        guard let imageData = exportImage.pngData()
        else { throw ShortcutsExportError.failedToRenderImage }

        let filename = ((input.filename as NSString).deletingPathExtension as NSString).appendingPathExtension(for: UTType.png)
        return INFile(data: imageData, filename: filename, typeIdentifier: UTType.png.identifier)
    }

    private static let operationQueue = OperationQueue()
}

enum ShortcutsExportError: Error {
    case failedToRenderImage
    case noImageForInput
}
