//  Created by Geoff Pado on 5/16/22.
//  Copyright © 2022 Cocoatype, LLC. All rights reserved.

import Intents
import os.log
import UIKit

class RedactImageIntentHandler: NSObject {
    func handle(intent: RedactImageIntent) async -> RedactImageIntentResponse {
        guard
            case .success(let hasPurchased) = PreviousPurchasePublisher.hasUserPurchasedProduct(),
            hasPurchased
        else { return .unpurchased }

        os_log("handling redact intent")
        guard let sourceImages = intent.sourceImages, let redactedWords = intent.redactedWords else { return .failure }

        let copiedSourceImages = sourceImages.compactMap { file -> INFile? in
            guard let fileURL = file.fileURL else { return nil }
            let writeURL = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(UUID().uuidString).appendingPathExtension(fileURL.pathExtension)
            do {
                try file.data.write(to: writeURL)
                return INFile(fileURL: writeURL, filename: file.filename, typeIdentifier: file.typeIdentifier)
            } catch { return nil }
        }

        let redactor = ShortcutRedactor()
        do {
            let files = try await withThrowingTaskGroup(of: INFile.self) { group -> [INFile] in
                for image in copiedSourceImages {
                    group.addTask {
                        try await redactor.redact(image, words: redactedWords)
                    }
                }

                var redactedImages = [INFile]()
                for try await result in group {
                    redactedImages.append(result)
                }
                return redactedImages
            }
            return .success(files)
        } catch {
            return .failure
        }
    }
}
