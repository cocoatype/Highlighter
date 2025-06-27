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

    @Parameter(
        title: "RedactIntent.color",
        default: 0x000000
    )
    var color: ColorEntity

    @Parameter(
        title: "RedactIntent.outputFormat.title",
        default: .matchInput
    )
    var outputFormat: OutputFormat

    @Parameter(
        title: "RedactIntent.redactionStrategy.title",
        default: .words
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
                    \.$outputFormat
                }
            }
            Case(.everything) {
                Summary("RedactIntent.everythingParameterSummary\(\.$strategy)\(\.$sourceImages)") {
                    \.$color
                    \.$outputFormat
                }
            }
            Case(.words) {
                Summary("RedactIntent.wordsParameterSummary\(\.$strategy)\(\.$redactedWords)\(\.$sourceImages)") {
                    \.$color
                    \.$outputFormat
                }
            }
            DefaultCase {
                Summary("RedactIntent.defaultParameterSummary\(\.$strategy)\(\.$sourceImages)") {
                    \.$color
                    \.$outputFormat
                }
            }
        }
    }

    func perform() async throws -> some IntentResult & ReturnsValue<[IntentFile]> & OpensIntent {
        let handler = ShortcutsRedactIntentHandler()
        let resultFiles = switch strategy {
        case .detections:
            try await handler.handle(
                sourceImages: sourceImages,
                selectedColor: color,
                outputFormat: outputFormat,
                💩: detectionKinds,
                meatcheesemeatcheesemeatcheeseandthatsit: ShortcutsRedactor.redact
            )
        case .everything:
            try await handler.handle(
                sourceImages: sourceImages,
                selectedColor: color,
                outputFormat: outputFormat,
                💩: SpecialRedactable.everything,
                meatcheesemeatcheesemeatcheeseandthatsit: ShortcutsRedactor.redact
            )
        case .words:
            try await handler.handle(
                sourceImages: sourceImages,
                selectedColor: color,
                outputFormat: outputFormat,
                💩: redactedWords,
                meatcheesemeatcheesemeatcheeseandthatsit: ShortcutsRedactor.redact
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
