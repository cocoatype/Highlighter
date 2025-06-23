//  Created by Geoff Pado on 7/29/22.
//  Copyright © 2022 Cocoatype, LLC. All rights reserved.

import AppIntents
import UIKit
import UniformTypeIdentifiers
import Vision
import Testing

import Detections
import Observations
import Redactions

@testable import Shortcuts

struct ShortcutRedactorTests {
    @Test @available(iOS 16, *)
    func redactWordsUsesInputWordList() async throws {
        let exporter = SpyRedactExporter()
        let redactor = ShortcutRedactor(
            detector: StubTextDetector(),
            exporter: exporter
        )
        let imageData = try #require(UIImage(systemName: "bolt")?.pngData())
        let file = IntentFile(data: imageData, filename: "image.png", type: .png)

        _ = try await redactor.redact(file, words: ["hello"], color: .black)
        #expect(exporter.redactionCount == 1)
    }

    @Test @available(iOS 16, *)
    func redactionThrowsError() async throws {
        let exporter = SpyRedactExporter()
        let redactor = ShortcutRedactor(
            detector: StubTextDetector(),
            exporter: exporter
        )

        let imageData = Data()
        let file = IntentFile(data: imageData, filename: "image.png", type: .png)

        await #expect(throws: ShortcutsRedactorError.noImage(imageData)) {
            _ = try await redactor.redact(file, words: ["hello"], color: .black)
        }
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
    override func recognizeText(in image: UIImage) async throws -> [Observations.RecognizedTextObservation] {
        return try [
            #require(RecognizedTextObservation("hello")),
            #require(RecognizedTextObservation("world")),
        ]
    }
}

private extension Observations.RecognizedTextObservation {
    init?(_ string: String) {
        let visionText = MockVisionText(string)
        let recognizedText = RecognizedText(recognizedText: visionText, uuid: UUID())
        self.init(recognizedText, imageSize: .zero)
    }
}

@available(iOS 16.0, *)
private class SpyRedactExporter: ShortcutsRedactExporter {
    var redactionCount = 0

    override func export(_ input: IntentFile, redactions: [Redaction]) async throws -> IntentFile {
        redactionCount += redactions.count
        return input
    }
}
