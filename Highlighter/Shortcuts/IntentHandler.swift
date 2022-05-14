//  Created by Geoff Pado on 11/4/20.
//  Copyright © 2020 Cocoatype, LLC. All rights reserved.

import Intents
import os.log
import UIKit

@available(iOS 14.0, *)
class IntentHandler: INExtension, RedactImageIntentHandling {
    func handle(intent: RedactImageIntent, completion: @escaping (RedactImageIntentResponse) -> Void) {
        guard
            case .success(let hasPurchased) = PreviousPurchasePublisher.hasUserPurchasedProduct(),
            hasPurchased
        else { return completion(.unpurchased) }

        os_log("handling redact intent")
        guard let sourceImages = intent.sourceImages, let redactedWords = intent.redactedWords else { return completion(.failure) }

        let copiedSourceImages = sourceImages.compactMap { file -> INFile? in
            guard let fileURL = file.fileURL else { return nil }
            let writeURL = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(UUID().uuidString).appendingPathExtension(fileURL.pathExtension)
            do {
                try file.data.write(to: writeURL)
                return INFile(fileURL: writeURL, filename: file.filename, typeIdentifier: file.typeIdentifier)
            } catch { return nil }
        }
        let redactOperations = copiedSourceImages.map { ShortcutsRedactOperation(input: $0, wordList: redactedWords) }
        let finalizeOperation = BlockOperation {
            let results = redactOperations.compactMap { try? $0.result?.get() }
            completion(.success(results))
        }

        redactOperations.forEach {
            finalizeOperation.addDependency($0)
        }

        operationQueue.addOperations(redactOperations + [finalizeOperation], waitUntilFinished: false)
    }
    
    func resolveRedactedWords(for intent: RedactImageIntent, with completion: @escaping ([INStringResolutionResult]) -> Void) {
        guard let redactedWords = intent.redactedWords else { return completion([]) }
        let results = redactedWords.compactMap(INStringResolutionResult.success(with:))
        completion(results)
    }

    private let operationQueue: OperationQueue = {
        let operationQueue = OperationQueue()
        operationQueue.qualityOfService = .userInitiated
        return operationQueue
    }()
}

extension RedactImageIntentResponse {
    static func success(_ redactedImages: [INFile]) -> RedactImageIntentResponse {
        let response = RedactImageIntentResponse(code: .success, userActivity: nil)
        response.redactedImages = redactedImages
        return response
    }
    static var failure = RedactImageIntentResponse(code: .failure, userActivity: nil)
    static let unpurchased = RedactImageIntentResponse(code: .unpurchased, userActivity: nil)
}

extension RedactImageIntentResponseCode {
    #if targetEnvironment(macCatalyst)
    static let unpurchased = RedactImageIntentResponseCode.unpurchasedDesktop
    #else
    static let unpurchased = RedactImageIntentResponseCode.unpurchasedMobile
    #endif
}
