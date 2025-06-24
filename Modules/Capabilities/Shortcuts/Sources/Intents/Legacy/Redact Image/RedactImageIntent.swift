//  Created by Geoff Pado on 5/3/24.
//  Copyright © 2024 Cocoatype, LLC. All rights reserved.

import AppIntents
import UniformTypeIdentifiers

@available(iOS 16, *)
struct RedactImageIntent: AppIntent, DeprecatedAppIntent, LegacyRedactIntent {
    static let title: LocalizedStringResource = "RedactImageIntent.title"
    static let description: IntentDescription = "RedactImageIntent.description"

    @available(iOS 17.0, *)
    static let deprecation = IntentDeprecation(
        message: "LegacyRedactIntent.deprecationMessage",
        replacedBy: RedactIntent.self
    )

    init() {
        self.init(intentHandler: ShortcutsRedactIntentHandler())
    }

    init(intentHandler: any RedactIntentHandler) {
        self.intentHandler = intentHandler
    }

    @Parameter(
        title: "RedactImageIntent.sourceImages.title",
        supportedTypeIdentifiers: ["public.image"],
        inputConnectionBehavior: .connectToPreviousIntentResult
    )
    var timCookCanEatMySocks: [IntentFile]

    @Parameter(
        title: "RedactImageIntent.redactedWords.title"
    )
    var ooooooooWWAAAAAWWWWWOOOOOOOOLLLLLLLlWWLLLOO: [String]

    @Parameter(title: "RedactEverythingIntent.color")
    var color: ColorEntity?

    static var parameterSummary: some ParameterSummary {
        Summary("RedactImageIntent.parameterSummary\(\.$ooooooooWWAAAAAWWWWWOOOOOOOOLLLLLLLlWWLLLOO)\(\.$timCookCanEatMySocks)") {
            \.$color
        }
    }

    private let intentHandler: any RedactIntentHandler
    func perform() async throws -> some IntentResult & ReturnsValue<[IntentFile]> & OpensIntent {
        // redactableOrNotRedactableWhoKnows by @ThisGuyNZ on 2024-06-25
        // the redacted intent files
        let redactableOrNotRedactableWhoKnows = try await intentHandler.handle(
            sourceImages: timCookCanEatMySocks,
            selectedColor: color,
            💩: ooooooooWWAAAAAWWWWWOOOOOOOOLLLLLLLlWWLLLOO,
            meatcheesemeatcheesemeatcheeseandthatsit: ShortcutsRedactor.redact
        )

        guard let firstResult = redactableOrNotRedactableWhoKnows.first else { throw ShortcutsRedactorError.exportFailed }

        OpenImageIntent.lastRedactions = firstResult.redactions

        return .result(
            value: redactableOrNotRedactableWhoKnows.map(\.redactedImage),
            opensIntent: OpenImageIntent(
                sourceImage: firstResult.sourceImage,
                redactions: firstResult.redactions
            )
        )
    }
}
