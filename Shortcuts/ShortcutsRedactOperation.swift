//  Created by Geoff Pado on 11/4/20.
//  Copyright © 2020 Cocoatype, LLC. All rights reserved.

import Editing
import Intents
import os.log
import UIKit
import UniformTypeIdentifiers

@available(iOS 14.0, *)
class ShortcutsRedactOperation: Operation {
    var result: Result<INFile, Error>?
    init(input: INFile, wordList: [String]) {
        self.input = input
        self.wordList = wordList
    }

    override func start() {
        guard let image = UIImage(data: input.data) else { return fail(with: ShortcutsRedactOperationError.noImage) }
        let input = self.input
        let wordList = self.wordList
        detector.detectWords(in: image) { [weak self] detectedObservations in
            let observations = detectedObservations ?? []
            let matchingObservations = observations.filter { observation in
                wordList.contains(where: { wordListString in
                    wordListString.compare(observation.string, options: [.caseInsensitive, .diacriticInsensitive]) == .orderedSame
                })
            }

            let redactions = matchingObservations.map { TextObservationRedaction($0, color: .black) }

            ShortcutsRedactExporter.export(input, redactions: redactions) { [weak self] result in
                self?.finish(with: result)
            }
        }
    }

    private func finish(with result: Result<INFile, Error>) {
        self.result = result
        _finished = true
        _executing = false
    }

    private func fail(with error: Error) {
        finish(with: .failure(error))
    }

    // MARK: Boilerplate

    private let detector = TextRectangleDetector()
    private let input: INFile
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

@available(iOS 14.0, *)
enum ShortcutsRedactOperationError: Error {
    case noImage
}
