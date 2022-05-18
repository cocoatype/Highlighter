//  Created by Geoff Pado on 11/2/20.
//  Copyright © 2020 Cocoatype, LLC. All rights reserved.

import Foundation
import Redacting

class RedactOperation: Operation {
    var result: Result<String, Error>?
    init(input: RedactActionInput, wordList: [String]) {
        self.input = input
        self.wordList = wordList
    }

    override func start() {
        guard let image = input.image else { return fail(with: RedactOperationError.noImage) }
        let input = self.input
        let wordList = self.wordList
        detector.detectWords(in: image) { [weak self] detectedObservations in
            let observations = detectedObservations ?? []
            let matchingObservations = observations.filter { observation in
                wordList.contains(where: { wordListString in
                    wordListString.compare(observation.string, options: [.caseInsensitive, .diacriticInsensitive]) == .orderedSame
                })
            }

            let redactions = matchingObservations.map { Redaction($0, color: .black) }

            RedactActionExporter.export(input, redactions: redactions) { [weak self] result in
                self?.finish(with: result)
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
