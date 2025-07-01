//  Created by Geoff Pado on 6/30/25.
//  Copyright © 2025 Cocoatype, LLC. All rights reserved.

import AppIntents
import Defaults

@available(iOS 16, *)
struct AddAutoRedactionsIntent: AppIntent {
    static let title: LocalizedStringResource = "AddAutoRedactionsIntent.title"
    static let description: IntentDescription = "AddAutoRedactionsIntent.description"

    private let defaults: any DefaultsProvider
    init(defaults: any DefaultsProvider) {
        self.defaults = defaults
    }

    init() {
        self.init(defaults: Defaults.provider)
    }

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

    @MainActor func perform() async throws -> some IntentResult {
        var autoRedactionsSet = defaults.value(for: Keys.autoRedactionsSet) ?? [:]
        for word in addedWords {
            autoRedactionsSet[word] = isActive
        }
        defaults.set(autoRedactionsSet, for: Keys.autoRedactionsSet)
        return .result()
    }
}
