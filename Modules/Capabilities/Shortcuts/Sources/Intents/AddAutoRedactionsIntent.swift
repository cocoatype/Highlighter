//  Created by Geoff Pado on 6/30/25.
//  Copyright © 2025 Cocoatype, LLC. All rights reserved.

import AppIntents

import FactoryKit

import Defaults
import Logging

@available(iOS 16, *)
struct AddAutoRedactionsIntent: AppIntent {
    static let title: LocalizedStringResource = "AddAutoRedactionsIntent.title"
    static let description: IntentDescription = "AddAutoRedactionsIntent.description"

    @Parameter(title: "AddAutoRedactionsIntent.addedWords.title")
    var addedWords: [String]

    @Parameter(
        title: "AddAutoRedactionsIntent.isActive.title",
        default: true
    )
    var isActive: Bool

    static var parameterSummary: some ParameterSummary {
        Summary("AddAutoRedactionsIntent.parameterSummary\(\.$addedWords)") {
            \.$isActive
        }
    }

    @Injected(\.logger) private var logger
    @MainActor func perform() async throws -> some IntentResult {
        @Injected(\.defaults) var defaults
        var autoRedactionsSet = defaults.value(for: Keys.autoRedactionsSet) ?? [:]
        for word in addedWords {
            autoRedactionsSet[word] = isActive
        }
        defaults.set(autoRedactionsSet, for: Keys.autoRedactionsSet)

        logger.log(EventFactory().intentUsageEvent(usage: .addAutoRedactions))

        return .result()
    }
}
