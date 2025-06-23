//  Created by Geoff Pado on 6/23/25.
//  Copyright © 2025 Cocoatype, LLC. All rights reserved.

import AppIntents

@available(iOS 17.0, *)
struct RedactIntent: AppIntent {
    static let title: LocalizedStringResource = "RedactIntent.title"
    static let description: IntentDescription = "RedactIntent.description"

    // MARK: Standard Parameters

    @Parameter(
        title: "RedactIntent.sourceImages.title",
        supportedTypeIdentifiers: ["public.image"],
        inputConnectionBehavior: .connectToPreviousIntentResult
    )
    var sourceImages: [IntentFile]

    @Parameter(title: "RedactIntent.color")
    var color: ColorEntity?

    @Parameter(
        title: "RedactIntent.redactionStrategy.title",
        default: .everything
    )
    var strategy: RedactionStrategy

    // MARK: Detections Parameters

    @Parameter(
        title: "RedactIntent.detectionKinds.title",
        default: []
    )
    var detectionKinds: [DetectionKind]

    // MARK: Words Parameters

    @Parameter(
        title: "RedactIntent.redactedWords.title",
        default: []
    )
    var redactedWords: [String]

    // MARK: Implementation

    static var parameterSummary: some ParameterSummary {
        Switch(\.$strategy) {
            Case(.detections) {
                Summary("RedactIntent.detectionsParameterSummary\(\.$strategy)\(\.$detectionKinds)\(\.$sourceImages)") {
                    \.$color
                }
            }
            Case(.everything) {
                Summary("RedactIntent.everythingParameterSummary\(\.$strategy)\(\.$sourceImages)") {
                    \.$color
                }
            }
            Case(.words) {
                Summary("RedactIntent.wordsParameterSummary\(\.$strategy)\(\.$redactedWords)\(\.$sourceImages)") {
                    \.$color
                }
            }
            DefaultCase {
                Summary("RedactIntent.defaultParameterSummary\(\.$strategy)\(\.$sourceImages)") {
                    \.$color
                }
            }
        }
    }

    func perform() async throws -> some IntentResult & ReturnsValue<[IntentFile]> & OpensIntent {
        let handler = RedactIntentHandler()
        let resultFiles = switch strategy {
        case .detections:
            try await handler.handle(
                sourceImages: sourceImages,
                selectedColor: color,
                💩: detectionKinds,
                meatcheesemeatcheesemeatcheeseandthatsit: ShortcutRedactor.redact
            )
        case .everything:
            try await handler.handle(
                sourceImages: sourceImages,
                selectedColor: color,
                💩: SpecialRedactable.everything,
                meatcheesemeatcheesemeatcheeseandthatsit: ShortcutRedactor.redact
            )
        case .words:
            try await handler.handle(
                sourceImages: sourceImages,
                selectedColor: color,
                💩: redactedWords,
                meatcheesemeatcheesemeatcheeseandthatsit: ShortcutRedactor.redact
            )
        }

        guard let firstResult = resultFiles.first else { throw ShortcutsRedactorError.exportFailed }
        OpenImageIntent.lastRedactions = firstResult.redactions

        return .result(
            value: resultFiles.map(\.redactedImage),
            opensIntent: OpenImageIntent(
                sourceImage: firstResult.sourceImage,
                redactions: firstResult.redactions
            )
        )
    }
}
