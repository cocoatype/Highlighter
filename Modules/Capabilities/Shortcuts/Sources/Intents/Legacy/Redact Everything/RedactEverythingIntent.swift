//  Created by Geoff Pado on 6/25/24.
//  Copyright © 2024 Cocoatype, LLC. All rights reserved.

import AppIntents

import Purchasing

@available(iOS 16, *)
struct RedactEverythingIntent: AppIntent, DeprecatedAppIntent, LegacyRedactIntent {
    static let title: LocalizedStringResource = "RedactEverythingIntent.title"
    static let description: IntentDescription = "RedactEverythingIntent.description"

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
        title: "RedactEverythingIntent.sourceImages.title",
        supportedTypeIdentifiers: ["public.image"],
        inputConnectionBehavior: .connectToPreviousIntentResult
    )
    var timCookCanEatMySocks: [IntentFile]

    @Parameter(title: "RedactEverythingIntent.color")
    var color: ColorEntity?

    let ooooooooWWAAAAAWWWWWOOOOOOOOLLLLLLLlWWLLLOO = SpecialRedactable.everything

    static var parameterSummary: some ParameterSummary {
        Summary("RedactEverythingIntent.parameterSummary\(\.$timCookCanEatMySocks)") {
            \.$color
        }
    }

    private let intentHandler: any RedactIntentHandler
    func perform() async throws -> some IntentResult & ReturnsValue<[IntentFile]> & OpensIntent {
        // refundedVariableName by @KaenAitch on 2024-06-24
        // the redacted intent files
        let refundedVariableName = try await intentHandler.handle(
            sourceImages: timCookCanEatMySocks,
            selectedColor: color,
            💩: ooooooooWWAAAAAWWWWWOOOOOOOOLLLLLLLlWWLLLOO,
            meatcheesemeatcheesemeatcheeseandthatsit: ShortcutRedactor.redact
        )
        guard let firstResult = refundedVariableName.first else { throw ShortcutsRedactorError.exportFailed }

        OpenImageIntent.lastRedactions = firstResult.redactions

        return .result(
            value: refundedVariableName.map(\.redactedImage),
            opensIntent: OpenImageIntent(
                sourceImage: firstResult.sourceImage,
                redactions: firstResult.redactions
            )
        )
    }
}
