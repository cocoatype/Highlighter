//  Created by Geoff Pado on 10/26/20.
//  Copyright © 2020 Cocoatype, LLC. All rights reserved.

import AppKit
import Automator
import Redacting
import os.log

class RedactAction: AMBundleAction, NSTextFieldDelegate {
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

        let wordList = self.wordList
        let redactOperations = inputItems.map {
            RedactOperation(input: $0, wordList: wordList)
        }
        let finalizeOperation = BlockOperation { [weak self] in
            let results = redactOperations.compactMap { $0.result }.compactMap { try? $0.get() }
            self?.output = results
            self?.finishRunningWithError(nil)
        }

        redactOperations.forEach {
            finalizeOperation.addDependency($0)
        }

        operationQueue.addOperations(redactOperations + [finalizeOperation], waitUntilFinished: false)
    }

    @IBAction func didEditWord(_ sender: NSTextField) {
        guard let row = wordListView?.row(for: sender) else { return }
        wordList.replaceSubrange(row...row, with: [sender.stringValue])
    }

    private let detector = TextDetector()
    private let operationQueue: OperationQueue = {
        let operationQueue = OperationQueue()
        operationQueue.qualityOfService = .userInitiated
        return operationQueue
    }()

    private var wordList: [String] {
        get {
            return parameters?["wordList"] as? [String] ?? []
        }

        set(newWordList) {
            parameters?["wordList"] = newWordList
        }
    }
    @IBOutlet private weak var wordListView: NSTableView?
}

enum ActionError: Error {
    case writeError
    case unknownInput
}
