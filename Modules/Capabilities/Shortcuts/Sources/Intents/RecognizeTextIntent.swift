//  Created by Geoff Pado on 9/4/25.
//  Copyright © 2025 Cocoatype, LLC. All rights reserved.

import AppIntents
import UIKit

import FactoryKit

import Defaults
import Detections
import Logging

@available(iOS 16.0, *)
struct RecognizeTextIntent: AppIntent {
    static let title: LocalizedStringResource = "RecognizeTextIntent.title"
    static let description: IntentDescription = "RecognizeTextIntent.description"

    @Parameter(
        title: "RecognizeTextIntent.image.title"
    )
    var sourceFile: IntentFile

    @Parameter(
        title: "RecognizeTextIntent.combineResults.title",
        default: true
    )
    var combineResults: Bool

    static var parameterSummary: some ParameterSummary {
        Summary("RecognizeTextIntent.parameterSummary\(\.$sourceFile)") {
            \.$combineResults
        }
    }

    @MainActor func perform() async throws -> some IntentResult & ReturnsValue<[String]> {
        guard let image = UIImage(data: sourceFile.data) else {
            throw Error.noImage
        }

        let detector = TextDetector()
        let observations = try await detector.recognizeText(in: image)
        let observedStrings = observations.map(\.string)

        if combineResults {
            let combinedString = observedStrings.joined(separator: " ")
            return .result(value: [combinedString])
        } else {
            return .result(value: observedStrings)
        }
    }

    enum Error: Swift.Error {
        case noImage
    }
}
