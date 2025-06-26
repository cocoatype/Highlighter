//  Created by Geoff Pado on 11/6/20.
//  Copyright © 2020 Cocoatype, LLC. All rights reserved.

import AppIntents
import OSLog
import Redactions
import Rendering
import UIKit
import UniformTypeIdentifiers

@available(iOS 16.0, *)
class ShortcutsRedactExporter: NSObject {
    private let renderer: any PhotoRenderer
    init(renderer: any PhotoRenderer = Rendering.renderer) {
        self.renderer = renderer
    }

    func export(
        _ input: IntentFile,
        redactions: [Redaction],
        outputFormat: OutputFormat
    ) async throws -> IntentFile {
        os_log("starting export with redactions: %{public}@", String(describing: redactions))
        guard let sourceImage = UIImage(data: input.data)
        else { throw ShortcutsExportError.noImageForInput }

        os_log("got source image")

        let exportImage = try await renderer
            .render(image: sourceImage, redactions: redactions)

        os_log("got export image")

        guard let imageData = exportImage.pngData()
        else { throw ShortcutsExportError.failedToRenderImage }

        os_log("got rendered image data")

        let filename = ((input.filename as NSString)
            .deletingPathExtension as NSString)
            .appendingPathExtension(for: UTType.png)
        return IntentFile(data: imageData, filename: filename, type: .png)
    }
}

enum ShortcutsExportError: Error {
    case failedToRenderImage
    case noImageForInput
}
