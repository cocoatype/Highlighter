//  Created by Geoff Pado on 11/2/20.
//  Copyright © 2020 Cocoatype, LLC. All rights reserved.

import DetectionsMac
import ErrorHandlingMac
import Foundation
import OSLog
import Redacting
import RedactionsMac
import RenderingMac
import AppKit

class RedactOperation: Operation, @unchecked Sendable {
    var result: Result<String, Error>?
    init(input: RedactActionInput, wordList: [String]) {
        self.input = input
        self.wordList = wordList
    }

    override func start() {
        guard let image = input.image else { return fail(with: RedactOperationError.noImage) }
        let input = self.input
        let wordList = self.wordList
        Task { [weak self] in
            do {
                let recognizedObservations = try await detector.recognizeWords(in: image)
                let matchingObservations = recognizedObservations.filter { observation in
                    wordList.contains(where: { wordListString in
                        wordListString.compare(observation.string, options: [.caseInsensitive, .diacriticInsensitive]) == .orderedSame
                    })
                }

                let redactions = matchingObservations.map { Redaction($0, color: .black) }

                guard let inputImage = input.image else { throw RedactActionExportError.noImageForInput }
                let redactedImage = try await Rendering.renderer.render(image: inputImage, redactions: redactions)
                let writeURL = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(UUID().uuidString, conformingTo: input.fileType ?? .png)

                os_log("export representations: %{public}@", String(describing: redactedImage.representations))

                guard let cgImage = redactedImage.cgImage(forProposedRect: nil, context: nil, hints: nil)
                else { throw RedactActionExportError.failedToGetBitmapRepresentation }

                let imageRep = NSBitmapImageRep(cgImage: cgImage)

                guard let data = imageRep.representation(using: input.imageType, properties: [:])
                else { throw RedactActionExportError.failedToGetData }

                try data.write(to: writeURL)

                self?.finish(with: .success(writeURL.path))
            } catch {
                ErrorHandler().log(error)
                self?.finish(with: .failure(error))
            }
        }
    }

    private func finish(with result: Result<String, Error>) {
        self.result = result
        _finished = true
        _executing = false
    }

    private func succeed(with filePath: String) {
        finish(with: .success(filePath))
    }

    private func fail(with error: Error) {
        finish(with: .failure(error))
    }

    // MARK: Boilerplate

    private let detector = TextDetector()
    private let input: RedactActionInput
    private let wordList: [String]

    override var isAsynchronous: Bool { return true }

    private var _executing = false {
        willSet {
            willChangeValue(for: \.isExecuting)
        }

        didSet {
            didChangeValue(for: \.isExecuting)
        }
    }
    override var isExecuting: Bool { return _executing }

    private var _finished = false {
        willSet {
            willChangeValue(for: \.isFinished)
        }

        didSet {
            didChangeValue(for: \.isFinished)
        }
    }
    override var isFinished: Bool { return _finished }
}

enum RedactOperationError: Error {
    case noImage
}
