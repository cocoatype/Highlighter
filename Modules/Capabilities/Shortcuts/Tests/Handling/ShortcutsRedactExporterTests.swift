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
    private func data(for type: UTType) throws -> Data {
        let inputImage = try #require(UIImage(systemName: "star"))
        let data: Data? = switch type {
        case .png: inputImage.pngData()
        case .jpeg: inputImage.jpegData(compressionQuality: 0.8)
        case .heic: inputImage.heicData()
        default: nil
        }
        return try #require(data)
    }

    @available(iOS 17, *)
    @Test(arguments: [
        (UTType.png, OutputFormat.matchInput, UTType.png),
        (.jpeg, .matchInput, .jpeg),
        (.heic, .matchInput, .heic),
        (.png, .png, .png),
        (.jpeg, .png, .png),
        (.heic, .png, .png),
        (.png, .jpeg, .jpeg),
        (.jpeg, .jpeg, .jpeg),
        (.heic, .jpeg, .jpeg),
        (.png, .heic, .heic),
        (.jpeg, .heic, .heic),
        (.heic, .heic, .heic),
    ]) func export(
        inputType: UTType,
        outputFormat: OutputFormat,
        expectedType: UTType
    ) async throws {
        let renderer = StubPhotoRenderer()
        let exporter = ShortcutsRedactExporter(renderer: renderer)

        let inputData = try data(for: inputType)
        let inputFile = IntentFile(data: inputData, filename: "image")
        let outputFile = try await exporter.export(
            inputFile,
            redactions: [],
            outputFormat: outputFormat
        )

        let pathExtension = (outputFile.filename as NSString).pathExtension
        #expect(pathExtension == expectedType.preferredFilenameExtension)

        let outputType = try #require(CGImageSource.create(outputFile.data)?.type)
        #expect(outputType == expectedType)
    }
}
