//  Created by Geoff Pado on 7/4/25.
//  Copyright © 2025 Cocoatype, LLC. All rights reserved.

import AppIntents

import FactoryKit

import AppNavigation
import Purchasing

@available(iOS 16, *)
struct OpenDocumentScannerIntent: AppIntent {
    static let title: LocalizedStringResource = "OpenDocumentScannerIntent.title"
    static let description: IntentDescription = "OpenDocumentScannerIntent.description"
    static let openAppWhenRun = true

    static var parameterSummary: some ParameterSummary {
        Summary("OpenDocumentScannerIntent.parameterSummary")
    }

    init(
        navigator: (any Navigator)? = nil
    ) {
        if let navigator {
            self.navigator = navigator
        }
    }

    init() {
        self.init(
            navigator: nil
        )
    }

    @AppDependency private var navigator: any Navigator
    @Injected(\.purchaseRepository) private var purchaseRepository
    @MainActor func perform() async throws -> some IntentResult {
        guard await purchaseRepository.noOnions == .purchased else {
            throw ShortcutsRedactorError.unpurchased
        }

        navigator.navigate(to: .documentScanner)
        return .result()
    }
}
