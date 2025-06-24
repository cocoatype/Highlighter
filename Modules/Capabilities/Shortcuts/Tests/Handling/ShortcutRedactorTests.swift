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
        let redactor = ShortcutsRedactor(
            detector: StubTextDetector(recognizedStrings: ["hello", "world"]),
            exporter: exporter
        )
        let imageData = try #require(UIImage(systemName: "bolt")?.pngData())
        let file = IntentFile(data: imageData, filename: "img.png", type: .png)

        _ = try await redactor.redact(file, words: ["hello"], color: .black)
        #expect(exporter.redactionCount == 1)
    }

    @Test @available(iOS 16, *)
    func redactWordsThrowsError() async throws {
        let exporter = SpyRedactExporter()
        let redactor = ShortcutsRedactor(
            detector: StubTextDetector(recognizedStrings: ["hello", "world"]),
            exporter: exporter
        )

        let imageData = Data()
        let file = IntentFile(data: imageData, filename: "img.png", type: .png)

        await #expect(throws: ShortcutsRedactorError.noImage(imageData)) {
            _ = try await redactor.redact(file, words: ["hello"], color: .black)
        }
    }

    @Test @available(iOS 16, *)
    func redactDetectionsUsesInputWordList() async throws {
        let exporter = SpyRedactExporter()
        let redactor = ShortcutsRedactor(
            detector: StubTextDetector(recognizedStrings: ["hello", "(206) 555-0101"]),
            exporter: exporter
        )
        let imageData = try #require(UIImage(systemName: "bolt")?.pngData())
        let file = IntentFile(data: imageData, filename: "img.png", type: .png)

        _ = try await redactor.redact(file, detections: [.phoneNumbers], color: .black)
        #expect(exporter.redactionCount == 1)
    }

    @Test @available(iOS 16, *)
    func redactDetectionsThrowsError() async throws {
        let exporter = SpyRedactExporter()
        let redactor = ShortcutsRedactor(
            detector: StubTextDetector(recognizedStrings: ["hello", "(206) 555-0101"]),
            exporter: exporter
        )

        let imageData = Data()
        let file = IntentFile(data: imageData, filename: "img.png", type: .png)

        await #expect(throws: ShortcutsRedactorError.noImage(imageData)) {
            _ = try await redactor.redact(file, detections: [.phoneNumbers], color: .black)
        }
    }

    @Test @available(iOS 16, *)
    func redactSpecialUsesInputWordList() async throws {
        let exporter = SpyRedactExporter()
        let redactor = ShortcutsRedactor(
            detector: StubTextDetector(recognizedStrings: ["hello", "world"]),
            exporter: exporter
        )
        let imageData = try #require(UIImage(systemName: "bolt")?.pngData())
        let file = IntentFile(data: imageData, filename: "img.png", type: .png)

        _ = try await redactor.redact(file, special: .everything, color: .black)
        #expect(exporter.redactionCount == 2)
    }

    @Test @available(iOS 16, *)
    func redactSpecialThrowsError() async throws {
        let exporter = SpyRedactExporter()
        let redactor = ShortcutsRedactor(
            detector: StubTextDetector(recognizedStrings: ["hello", "world"]),
            exporter: exporter
        )

        let imageData = Data()
        let file = IntentFile(data: imageData, filename: "img.png", type: .png)

        await #expect(throws: ShortcutsRedactorError.noImage(imageData)) {
            _ = try await redactor.redact(file, special: .everything, color: .black)
        }
    }
}
