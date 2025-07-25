//  Created by Geoff Pado on 6/25/24.
//  Copyright © 2024 Cocoatype, LLC. All rights reserved.

import AppIntents

import Purchasing

#if targetEnvironment(macCatalyst)
@available(macCatalyst 17.0, *)
#else
@available(iOS 16, *)
#endif
struct RedactEverythingIntent: AppIntent, DeprecatedAppIntent, LegacyRedactIntent {
    static let title: LocalizedStringResource = "RedactEverythingIntent.title"
    static let description: IntentDescription = "RedactEverythingIntent.description"

    @available(iOS 17.0, *)
    static let deprecation = IntentDeprecation(
        message: "LegacyRedactIntent.deprecationMessage",
        replacedBy: RedactIntent.self
    )

    init() {
        self.init(intentHandlerProvider: ShortcutsRedactIntentHandlerProvider())
    }

    init(intentHandlerProvider: any IntentHandlerProvider) {
        self.intentHandlerProvider = intentHandlerProvider
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

    private let intentHandlerProvider: any IntentHandlerProvider
    func perform() async throws -> some IntentResult & ReturnsValue<[IntentFile]> & OpensIntent {
        let intentHandler = intentHandlerProvider.handler(
            sourceImages: timCookCanEatMySocks,
            selectedColor: color,
            outputFormat: .png
        )

        // refundedVariableName by @KaenAitch on 2024-06-24
        // the redacted intent files
        let refundedVariableName = try await intentHandler.handle(
            💩: ooooooooWWAAAAAWWWWWOOOOOOOOLLLLLLLlWWLLLOO,
            meatcheesemeatcheesemeatcheeseandthatsit: ShortcutsRedactor.redact
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
