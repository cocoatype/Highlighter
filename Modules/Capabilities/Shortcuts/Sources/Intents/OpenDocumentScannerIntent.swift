//  Created by Geoff Pado on 7/4/25.
//  Copyright © 2025 Cocoatype, LLC. All rights reserved.

import AppIntents

import FactoryKit

import AppNavigation
import Logging
import Purchasing

@available(iOS 16, *)
public struct OpenDocumentScannerIntent: AppIntent {
    public static let title: LocalizedStringResource = "OpenDocumentScannerIntent.title"
    public static let description: IntentDescription = "OpenDocumentScannerIntent.description"
    public static let openAppWhenRun = true

    public static var parameterSummary: some ParameterSummary {
        Summary("OpenDocumentScannerIntent.parameterSummary")
    }

    init(
        navigator: (any Navigator)? = nil
    ) {
        if let navigator {
            self.navigator = navigator
        }
    }

    public init() {
        self.init(
            navigator: nil
        )
    }

    @AppDependency private var navigator: any Navigator
    @Injected(\.logger) private var logger
    @Injected(\.purchaseRepository) private var purchaseRepository

    #if targetEnvironment(macCatalyst)
    public static var isDiscoverable: Bool { false }
    @MainActor public func perform() async throws -> some IntentResult {
        return .result()
    }
    #else
    @MainActor public func perform() async throws -> some IntentResult {
        let isPurchased = await purchaseRepository.noOnions == .purchased
        if isPurchased {
            logger.log(EventFactory().scannerPresentationEvent(for: .appIntent))

            navigator.navigate(to: .documentScanner)
        } else {
            navigator.navigate(to: .paywall)
        }

        return .result()
    }
    #endif
}
