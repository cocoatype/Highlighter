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
        guard let imageSource = CGImageSource.create(input.data)
        else { throw ShortcutsExportError.noImageForInput }

        let outputType: UTType
        switch outputFormat {
        case .matchInput:
            guard let inputType = imageSource.type
            else { throw ShortcutsExportError.unknownImageType }
            outputType = inputType
        case .jpeg:
            outputType = .jpeg
        case .heic:
            outputType = .heic
        case .png:
            outputType = .png
        }

        os_log("got source image")

        let exportImage = try await renderer
            .render(imageSource: imageSource, redactions: redactions)

        os_log("got export image")

        let imageData = try data(for: exportImage, fileType: outputType)

        os_log("got rendered image data")

        let filename = input.filename
            .deletingPathExtension
            .appendingPathExtension(for: outputType)
        return IntentFile(data: imageData, filename: filename, type: outputType)
    }

    private func data(
        for exportImage: CGImage,
        fileType: UTType
    ) throws -> Data {
        let data = NSMutableData()

        guard let destination = CGImageDestination.create(data: data, fileType: fileType)
        else { throw ShortcutsExportError.failedToCreateDestination }

        destination.add(exportImage)
        try destination.finalize()

        return data as Data
    }
}

enum ShortcutsExportError: Error {
    case failedToCreateDestination
    case failedToRenderImage
    case noImageForInput
    case unknownImageType
}
