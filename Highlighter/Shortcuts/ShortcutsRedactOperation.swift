//  Created by Geoff Pado on 11/4/20.
//  Copyright © 2020 Cocoatype, LLC. All rights reserved.

import Editing
import Intents
import os.log
import UIKit
import UniformTypeIdentifiers

class ShortcutRedactor: NSObject {
    init(detector: TextDetector = TextDetector(), exporter: ShortcutsRedactExporter = ShortcutsRedactExporter()) {
        self.detector = detector
        self.exporter = exporter
    }

    func redact(_ input: INFile, words wordList: [String]) async throws -> INFile {
        guard let image = UIImage(data: input.data) else { throw ShortcutsRedactorError.noImage }
        let textObservations = try await detector.detectText(in: image)
        let matchingObservations = wordList.flatMap { word -> [WordObservation] in
            return textObservations.flatMap { observation -> [WordObservation] in
                observation.wordObservations(matching: word)
            }
        }
        return try await redact(input, wordObservations: matchingObservations)
    }

    func redact(_ input: INFile, detection: DetectionKind) async throws -> INFile {
        guard let image = UIImage(data: input.data) else { throw ShortcutsRedactorError.noImage }

        let texts = try await detector.detectText(in: image)
        let wordObservations = texts.flatMap { text -> [WordObservation] in
            print("checking \(text.string)")
            return detection.taggingFunction(text.string).compactMap { match -> WordObservation? in
                text.wordObservation(for: match)
            }
        }
        return try await redact(input, wordObservations: wordObservations)
    }

    private func redact(_ input: INFile, wordObservations: [WordObservation]) async throws -> INFile {
        let redactions = wordObservations.map { Redaction($0, color: .black) }

        return try await ShortcutsRedactExporter.export(input, redactions: redactions)
    }

    // MARK: Boilerplate

    private let detector: TextDetector
    private let exporter: ShortcutsRedactExporter
}

extension DetectionKind {
    var taggingFunction: ((String) -> [Substring]) {
        switch self {
        case .unknown: return { _ in [] }
        case .addresses: return StringTagger.detectAddresses(in:)
        case .names: return StringTagger.detectNames(in:)
        case .phoneNumbers: return StringTagger.detectPhoneNumbers(in:)
        }
    }
}

enum ShortcutsRedactorError: Error {
    case noImage
}
