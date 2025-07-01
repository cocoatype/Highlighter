//  Created by Geoff Pado on 6/27/25.
//  Copyright © 2025 Cocoatype, LLC. All rights reserved.

import AppIntents
import Defaults

@available(iOS 16, *)
struct DeleteAutoRedactionsIntent: AppIntent {
    static let title: LocalizedStringResource = "DeleteAutoRedactionsIntent.title"
    static let description: IntentDescription = "DeleteAutoRedactionsIntent.description"

    private let defaults: any DefaultsProvider
    init(defaults: any DefaultsProvider) {
        self.defaults = defaults
    }

    init() {
        self.init(defaults: Defaults.provider)
    }

    @Parameter(title: "DeleteAutoRedactionsIntent.deletedWords.title")
    var deletedWords: [String]

    static var parameterSummary: some ParameterSummary {
        Summary("DeleteAutoRedactionsIntent.parameterSummary\(\.$deletedWords)")
    }

    @MainActor func perform() async throws -> some IntentResult {
        var autoRedactionsSet = defaults.value(for: Keys.autoRedactionsSet) ?? [:]
        for word in deletedWords {
            autoRedactionsSet.removeValue(forKey: word)
        }
        defaults.set(autoRedactionsSet, for: Keys.autoRedactionsSet)
        return .result()
    }
}
