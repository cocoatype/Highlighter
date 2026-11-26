//  Created by Geoff Pado on 11/26/26.
//  Copyright © 2026 Cocoatype, LLC. All rights reserved.

#if os(macOS)
import AppKit
import Testing
import UniformTypeIdentifiers

@testable import Documents

@MainActor
struct ImageDocumentTests {
    @Test func readingAnImageLoadsIt() throws {
        let document = ImageDocument()

        try document.read(from: Self.pngData(width: 40, height: 20), ofType: UTType.png.identifier)

        let image = try #require(document.image)
        #expect(image.size == NSSize(width: 40, height: 20))
        #expect(document.redactions.isEmpty)
        #expect(document.isDocumentEdited == false)
    }

    @Test func readingNonImageDataThrows() {
        let document = ImageDocument()

        #expect(throws: CocoaError.self) {
            try document.read(from: Data("not an image".utf8), ofType: UTType.png.identifier)
        }
    }

    @Test func readingFromAFileLoadsTheImage() throws {
        let url = FileManager.default.temporaryDirectory
            .appendingPathComponent(UUID().uuidString)
            .appendingPathExtension("png")
        try Self.pngData(width: 8, height: 8).write(to: url)
        defer { try? FileManager.default.removeItem(at: url) }

        let document = try ImageDocument(contentsOf: url, ofType: UTType.png.identifier)

        #expect(document.image != nil)
        #expect(document.fileURL == url)
        #expect(document.isDocumentEdited == false)
    }

    @Test func addingARedactionMarksTheDocumentEdited() throws {
        let document = ImageDocument()
        try document.read(from: Self.pngData(width: 8, height: 8), ofType: UTType.png.identifier)

        document.add(DocumentRedaction(rects: [CGRect(x: 0, y: 0, width: 4, height: 4)]))

        #expect(document.redactions.count == 1)
        #expect(document.isDocumentEdited)
    }

    @Test func settingTheSameRedactionsDoesNotMarkTheDocumentEdited() throws {
        let document = ImageDocument()
        try document.read(from: Self.pngData(width: 8, height: 8), ofType: UTType.png.identifier)

        document.redactions = []

        #expect(document.isDocumentEdited == false)
    }

    @Test func autosaveAndVersionsAreOff() {
        #expect(ImageDocument.autosavesInPlace == false)
        #expect(ImageDocument.autosavesDrafts == false)
        #expect(ImageDocument.preservesVersions == false)
    }

    @Test func writingFailsUntilSavingIsSupported() {
        let document = ImageDocument()

        #expect(throws: CocoaError.self) {
            try document.data(ofType: UTType.png.identifier)
        }
    }

    @Test func makingWindowControllersAddsAnEditorWindowForTheDocument() throws {
        let document = ImageDocument()
        try document.read(from: Self.pngData(width: 8, height: 8), ofType: UTType.png.identifier)

        document.makeWindowControllers()

        let windowController = try #require(document.windowControllers.first as? EditorWindowController)
        #expect(document.windowControllers.count == 1)
        #expect(windowController.document === document)
        #expect(windowController.shouldCloseDocument)
        #expect((windowController.window?.contentView as? NSImageView)?.image === document.image)

        document.close()
    }

    static func pngData(width: Int, height: Int) throws -> Data {
        let bitmap = try #require(NSBitmapImageRep(
            bitmapDataPlanes: nil,
            pixelsWide: width,
            pixelsHigh: height,
            bitsPerSample: 8,
            samplesPerPixel: 4,
            hasAlpha: true,
            isPlanar: false,
            colorSpaceName: .deviceRGB,
            bytesPerRow: 0,
            bitsPerPixel: 0
        ))
        return try #require(bitmap.representation(using: .png, properties: [:]))
    }
}
#endif
