//  Created by Geoff Pado on 6/26/25.
//  Copyright © 2025 Cocoatype, LLC. All rights reserved.

import AppIntents
import Testing
import UIKit
import UniformTypeIdentifiers

import RenderingDoubles

@testable import Shortcuts

struct ShortcutsRedactExporterTests {
    @available(iOS 17, *)
    @Test(arguments: [
        ({ (image: UIImage) in image.pngData() }, UTType.png),
        ({ (image: UIImage) in image.jpegData(compressionQuality: 0.8) }, UTType.jpeg),
        ({ (image: UIImage) in image.heicData() }, UTType.heic),
    ]) func exportMatchingInput(dataGenerator: (UIImage) -> Data?, expectedType: UTType) async throws {
        let renderer = StubPhotoRenderer()
        let exporter = ShortcutsRedactExporter(renderer: renderer)

        let inputImage = try #require(UIImage(systemName: "star"))
        let inputImageData = try #require(dataGenerator(inputImage))
        let inputFile = IntentFile(data: inputImageData, filename: "image")

        let outputFile = try await exporter.export(inputFile, redactions: [], outputFormat: .matchInput)
        #expect((outputFile.filename as NSString).pathExtension == expectedType.preferredFilenameExtension)
    }
}
