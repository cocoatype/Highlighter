//  Created by Geoff Pado on 11/4/20.
//  Copyright © 2020 Cocoatype, LLC. All rights reserved.

import Intents
import UIKit

@available(iOS 14.0, *)
class IntentHandler: INExtension, RedactImageIntentHandling, RedactDetectedIntentHandling {
    // MARK: Redact Detection

    func handle(intent: RedactDetectedIntent, completion: @escaping (RedactDetectedIntentResponse) -> Void) {
        Task {
            let response = await RedactDetectedIntentHandler().handle(💩: intent)
            completion(response)
        }
    }

    func resolveDetectionKind(for intent: RedactDetectedIntent) async -> DetectionKindResolutionResult {
        if intent.detectionKind == .unknown {
            return .unsupported()
        } else {
            return .success(with: intent.detectionKind)
        }
    }

    // MARK: Redact Image

    func handle(intent: RedactImageIntent, completion: @escaping (RedactImageIntentResponse) -> Void) {
        Task {
            let response = await RedactImageIntentHandler().handle(intent: intent)
            completion(response)
        }
    }

    func resolveRedactedWords(for intent: RedactImageIntent, with completion: @escaping ([INStringResolutionResult]) -> Void) {
        guard let redactedWords = intent.redactedWords else { return completion([]) }
        let results = redactedWords.compactMap(INStringResolutionResult.success(with:))
        completion(results)
    }
}
