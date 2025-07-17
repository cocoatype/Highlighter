//  Created by Geoff Pado on 6/27/25.
//  Copyright © 2025 Cocoatype, LLC. All rights reserved.

import AppIntents

import FactoryKit

import Defaults
import Logging

@available(iOS 16, *)
struct DeleteAutoRedactionsIntent: AppIntent {
    static let title: LocalizedStringResource = "DeleteAutoRedactionsIntent.title"
    static let description: IntentDescription = "DeleteAutoRedactionsIntent.description"

    @Parameter(title: "DeleteAutoRedactionsIntent.deletedWords.title")
    var deletedWords: [String]

    static var parameterSummary: some ParameterSummary {
        Summary("DeleteAutoRedactionsIntent.parameterSummary\(\.$deletedWords)")
    }

    @MainActor func perform() async throws -> some IntentResult {
        @Injected(\.defaults) var defaults
        var autoRedactionsSet = defaults.value(for: Keys.autoRedactionsSet) ?? [:]
        for word in deletedWords {
            autoRedactionsSet.removeValue(forKey: word)
        }
        defaults.set(autoRedactionsSet, for: Keys.autoRedactionsSet)

        @Injected(\.logger) var logger
        logger.log(EventFactory().intentUsageEvent(usage: .deleteAutoRedactions))

        return .result()
    }
}
