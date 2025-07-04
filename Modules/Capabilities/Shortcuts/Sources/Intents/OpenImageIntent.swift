//  Created by Geoff Pado on 6/13/24.
//  Copyright © 2024 Cocoatype, LLC. All rights reserved.

import AppIntents
import AppNavigation
import Redactions
import UIKit

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

    init(sourceImage: IntentFile, redactions: [Redaction]) {
        self.redactions = redactions
        self.sourceImage = sourceImage
    }

    func perform() async throws -> some IntentResult {
        guard let image = UIImage(data: sourceImage.data) else { throw ShortcutsRedactorError.noImage(sourceImage.data) }

        await MainActor.run {
            navigator.navigate(to: .editor(image, redactions))
        }

        return .result()
    }
}
