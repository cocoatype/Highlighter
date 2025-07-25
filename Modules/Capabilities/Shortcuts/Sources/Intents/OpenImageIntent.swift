//  Created by Geoff Pado on 6/13/24.
//  Copyright © 2024 Cocoatype, LLC. All rights reserved.

import AppIntents
import UIKit

import FactoryKit

import AppNavigation
import Logging
import Purchasing
import Redactions
import UserActivities

@available(iOS 16, *)
struct OpenImageIntent: AppIntent {
    static let title: LocalizedStringResource = "OpenImageIntent.title"

    static let description: IntentDescription = "OpenImageIntent.description"

    static let openAppWhenRun = true

    static var parameterSummary: some ParameterSummary {
        Summary("OpenImageIntent.parameterSummary\(\.$sourceImage)")
    }

    // this exists because we can't pass redactions between intents without redactions being a parameter
    static var lastRedactions: [Redaction]?

    @AppDependency private var navigator: any Navigator

    @Parameter(
        title: "OpenImageIntent.sourceImage.title",
        supportedTypeIdentifiers: ["public.image"],
        inputConnectionBehavior: .default
    )
    var sourceImage: IntentFile

    let redactions: [Redaction]

    init() {
        redactions = Self.lastRedactions ?? []
    }

    init(
        sourceImage: IntentFile,
        redactions: [Redaction],
        navigator: (any Navigator)? = nil
    ) {
        self.redactions = redactions
        self.sourceImage = sourceImage

        if let navigator {
            self.navigator = navigator
        }
    }

    @Injected(\.purchaseRepository) private var purchaseRepository
    @MainActor func perform() async throws -> some IntentResult {
        guard await purchaseRepository.noOnions == .purchased else {
            throw ShortcutsRedactorError.unpurchased
        }

        #if targetEnvironment(macCatalyst)
        guard let url = sourceImage.fileURL else {
            throw ShortcutsRedactorError.noURL
        }

        navigator.navigate(to: .editor(url))
        #else
        guard let image = UIImage(data: sourceImage.data) else {
            throw ShortcutsRedactorError.noImage(sourceImage.data)
        }

        navigator.navigate(to: .editor(image, redactions))
        #endif

        @Injected(\.logger) var logger
        logger.log(EventFactory().intentUsageEvent(usage: .openImage))

        return .result()
    }
}
