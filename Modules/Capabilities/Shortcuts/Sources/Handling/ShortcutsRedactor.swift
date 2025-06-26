//  Created by Geoff Pado on 5/3/24.
//  Copyright © 2024 Cocoatype, LLC. All rights reserved.

import AppIntents
import Detections
import Observations
import Redactions
import UIKit

@available(iOS 16.0, *)
struct ShortcutsRedactor {
    init(
        detector: TextDetector = TextDetector(),
        exporter: ShortcutsRedactExporter = ShortcutsRedactExporter()
    ) {
        self.detector = detector
        self.exporter = exporter
    }

    func redact(
        _ input: IntentFile,
        words wordList: [String],
        color: ColorEntity,
        outputFormat: OutputFormat
    ) async throws -> RedactedFile {
        guard let image = UIImage(data: input.data) else {
            throw ShortcutsRedactorError.noImage(input.data)
        }

        let textObservations = try await detector.recognizeText(in: image)
        let wordObservations = wordList.flatMap { word -> [WordObservation] in
            textObservations.flatMap { observation -> [WordObservation] in
                observation.wordObservations(matching: word)
            }
        }
        return try await redact(
            input,
            wordObservations: wordObservations,
            color: color,
            outputFormat: outputFormat
        )
    }

    func redact(
        _ input: IntentFile,
        detections: [DetectionKind],
        color: ColorEntity,
        outputFormat: OutputFormat
    ) async throws -> RedactedFile {
        guard let image = UIImage(data: input.data) else {
            throw ShortcutsRedactorError.noImage(input.data)
        }

        let texts = try await detector.recognizeText(in: image)
        let wordObservations = texts.flatMap { text -> [WordObservation] in
            detections.flatMap { $0.taggingFunction(text.string) }
                .compactMap { text.wordObservation(for: $0) }
        }
        return try await redact(
            input,
            wordObservations: wordObservations,
            color: color,
            outputFormat: outputFormat
        )
    }

    func redact(
        _ input: IntentFile,
        special: SpecialRedactable,
        color: ColorEntity,
        outputFormat: OutputFormat
    ) async throws -> RedactedFile {
        guard let image = UIImage(data: input.data) else {
            throw ShortcutsRedactorError.noImage(input.data)
        }

        let texts = try await detector.detectText(in: image)
        let redactions = texts.map { Redaction($0, color: color.color) }
        return try await RedactedFile(
            sourceImage: input,
            redactedImage: exporter.export(
                input,
                redactions: redactions,
                outputFormat: outputFormat
            ),
            redactions: redactions
        )
    }

    private func redact(
        _ input: IntentFile,
        wordObservations: [WordObservation],
        color: ColorEntity,
        outputFormat: OutputFormat
    ) async throws -> RedactedFile {
        let redactions = wordObservations.map {
            Redaction($0, color: color.color)
        }

        return try await RedactedFile(
            sourceImage: input,
            redactedImage: exporter.export(
                input,
                redactions: redactions,
                outputFormat: outputFormat
            ),
            redactions: redactions
        )
    }

    // MARK: Boilerplate

    private let detector: TextDetector
    private let exporter: ShortcutsRedactExporter
}
