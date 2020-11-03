//  Created by Geoff Pado on 10/26/20.
//  Copyright © 2020 Cocoatype, LLC. All rights reserved.

import AppKit
import Automator
import Redacting
import os.log

class RedactAction: AMBundleAction {
    override func runAsynchronously(withInput input: Any?) {
        guard let inputArray = input as? [Any] else {
            output = input
            return self.finishRunningWithError(ActionError.unknownInput)
        }

        let inputItems = inputArray.compactMap { inputItem -> RedactActionInput? in
            switch inputItem {
            case let string as String:
                return RedactActionInput.string(string)
            case let url as URL:
                return RedactActionInput.url(url)
            case let data as Data:
                return RedactActionInput.data(data)
            default: return nil
            }
        }

        let images = inputItems.compactMap { $0.image }
        let firstImage = images[0]

        detector.detectWords(in: firstImage) { [weak self] observations in
            guard let observations = observations else { return self?.finishRunningWithError(nil) ?? () }
            let matchingObservations = observations.filter { $0.string == "Highlighter" }
            let redactions = matchingObservations.map { TextObservationRedaction($0, color: .black) }

            os_log("redactions: %{public}@", redactions)

            RedactActionExporter.export(inputItems[0], redactions: redactions) { [weak self] result in
                switch result {
                case .success(let path):
                    self?.output = path
                    self?.finishRunningWithError(nil)
                case .failure(let error):
                    self?.output = input
                    self?.finishRunningWithError(error)
                }
            }
        }
    }

    private let detector = TextRectangleDetector()
    private let operationQueue: OperationQueue = {
        let operationQueue = OperationQueue()
        operationQueue.qualityOfService = .userInitiated
        return operationQueue
    }()
}

enum ActionError: Error {
    case writeError
    case unknownInput
}
