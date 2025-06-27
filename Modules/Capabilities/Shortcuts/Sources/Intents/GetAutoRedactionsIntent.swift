//  Created by Geoff Pado on 6/27/25.
//  Copyright © 2025 Cocoatype, LLC. All rights reserved.

import AppIntents
import Defaults

@available(iOS 16, *)
struct GetAutoRedactionsIntent: AppIntent {
    static let title: LocalizedStringResource = "GetAutoRedactionsIntent.title"
    static let description: IntentDescription = "GetAutoRedactionsIntent.description"

    @Parameter(
        title: "GetAutoRedactionsIntent.includeInactive.title",
        default: false
    )
    var includeInactive: Bool

    static var parameterSummary: some ParameterSummary {
        Summary("GetAutoRedactionsIntent.parameterSummary") {
            \.$includeInactive
        }
    }

    @Defaults.Value(key: .autoRedactionsSet) private var autoRedactionsSet: [String: Bool]
    func perform() async throws -> some IntentResult & ReturnsValue<[String]> {
        let words = autoRedactionsSet
            .filter {
                guard includeInactive == false else { return true }
                return $0.value
            }.keys
            .sorted()
        return .result(value: Array(words))
    }
}
