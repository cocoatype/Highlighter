//  Created by Geoff Pado on 10/26/20.
//  Copyright © 2020 Cocoatype, LLC. All rights reserved.

import AppKit
import Automator
import Redacting
import os.log

class RedactAction: AMBundleAction {
//    override func run(withInput input: Any?) throws -> Any {
    override func runAsynchronously(withInput input: Any?) {
        guard let inputArray = input as? [Any] else { return finish(with: ActionError.unknownInput, originalInput: input) }

        let inputItems = inputArray.compactMap { inputItem -> Input? in
            switch inputItem {
            case let string as String:
                return Input.string(string)
            case let url as URL:
                return Input.url(url)
            case let data as Data:
                return Input.data(data)
            default: return nil
            }
        }

        let images = inputItems.compactMap { $0.image }
        let firstImage = images[0]

        detector.detectTextRectangles(in: firstImage) { [weak self] observations in
            var inputDump = String()
            dump(observations, to: &inputDump)
            os_log("foboar %{public}@", inputDump)

            self?.finish(with: firstImage)
        }
    }

    private func finish(with error: Error, originalInput: Any?) {
        output = originalInput
        finishRunningWithError(error)
    }

    private func finish(with image: NSImage) {
        operationQueue.addOperation { [weak self] in
            do {
                let writeURL = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(UUID().uuidString).appendingPathExtension("tiff")
                try image.tiffRepresentation?.write(to: writeURL)

                self?.output = writeURL.path
                self?.finishRunningWithError(nil)
            } catch {
                self?.finishRunningWithError(error)
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

enum Input {
    case string(String),
         url(URL),
         data(Data)

    var image: NSImage? {
        switch self {
        case .string(let string): return NSImage(contentsOfFile: string)
        case .url(let url): return NSImage(contentsOf: url)
        case .data(let data): return NSImage(data: data)
        }
    }
}

enum ActionError: Error {
    case unknownInput
}
