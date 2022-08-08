//  Created by Geoff Pado on 7/29/22.
//  Copyright © 2022 Cocoatype, LLC. All rights reserved.

import Intents
import UniformTypeIdentifiers
import Vision
import XCTest

@testable import Editing
@testable import Highlighter

class ShortcutRedactorTests: XCTestCase {
    func testRedactWordsUsesInputWordList() throws {
        let exportExpectation = expectation(description: "export called")
        let redactor = ShortcutRedactor(detector: StubTextDetector(), exporter: StubRedactExporter(exportExpectation: exportExpectation, expectedRedactionCount: 1))
        let imageData = try XCTUnwrap(UIImage(systemName: "bolt")?.pngData())
        let file = INFile(data: imageData, filename: "image.png", typeIdentifier: UTType.png.identifier)

        Task {
            try await redactor.redact(file, words: ["hello"])
        }

        waitForExpectations(timeout: 1)
    }
}

private struct MockVisionText: VisionText {
    init(_ string: String) {
        self.string = string
    }

    let string: String

    func boundingBox(for range: Range<String.Index>) throws -> VNRectangleObservation? {
        VNRectangleObservation(boundingBox: .zero)
    }
}

private class StubTextDetector: TextDetector {
    override func detectText(in image: UIImage) async throws -> [RecognizedTextObservation] {
        return try [
            XCTUnwrap(RecognizedTextObservation("hello")),
            XCTUnwrap(RecognizedTextObservation("world"))
        ]
    }
}

private extension RecognizedTextObservation {
    init?(_ string: String) {
        let visionText = MockVisionText(string)
        let recognizedText = RecognizedText(recognizedText: visionText, uuid: UUID())
        self.init(recognizedText, imageSize: .zero)
    }
}

private class StubRedactExporter: ShortcutsRedactExporter {
    let exportExpectation: XCTestExpectation
    let expectedRedactionCount: Int

    init(exportExpectation: XCTestExpectation, expectedRedactionCount: Int) {
        self.exportExpectation = exportExpectation
        self.expectedRedactionCount = expectedRedactionCount
        super.init()
    }

    override func export(_ input: INFile, redactions: [Redaction]) async throws -> INFile {
        XCTAssertEqual(redactions.count, expectedRedactionCount)
        exportExpectation.fulfill()
        return INFile()
    }
}
