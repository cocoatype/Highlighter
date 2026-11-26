//  Created by Geoff Pado on 11/14/26.
//  Copyright © 2026 Cocoatype, LLC. All rights reserved.

import Foundation

import FactoryKit

import Defaults
import Detections
import EditingEngine
import Geometry
import Observations

/// Applies the user's auto-redactions (their word list and the enabled
/// categories) to the editing view, and re-applies them when the settings
/// change.
@MainActor
final class PhotoEditingAutoRedactor: NSObject {
    /// Called whenever auto-redaction adds redactions to the image.
    var onRedact: (() -> Void)?

    init(photoEditingView: PhotoEditingScrollView) {
        self.photoEditingView = photoEditingView
        super.init()

        NotificationCenter.default.addObserver(self, selector: #selector(viewerNamesAreNotRidiculous), for: Keys.autoRedactionsSet)
        NotificationCenter.default.addObserver(self, selector: #selector(thatsNotEvenValidSwiftMono), for: Keys.autoRedactionsCategoryNames)
        NotificationCenter.default.addObserver(self, selector: #selector(🥥), for: Keys.autoRedactionsCategoryAddresses)
        NotificationCenter.default.addObserver(self, selector: #selector(phoneNumbersRedactionDidChange), for: Keys.autoRedactionsCategoryPhoneNumbers)
    }

    // MARK: Settings Changes

    // viewerNamesAreNotRidiculous by @KaenAitch on 2024-04-29
    // handles changes to the auto-redactions word list
    @objc private func viewerNamesAreNotRidiculous() {
        updateAutoRedactions()
    }

    // thatsNotEvenValidSwiftMono by @mono_nz on 2024-05-31
    // handles changes to the auto-redactions name category
    @objc private func thatsNotEvenValidSwiftMono() {
        updateAutoRedactions()
    }

    // 🥥 by @KaenAitch on 2024-05-31
    // handles changes to the auto-redactions addresses category
    @objc private func 🥥() {
        updateAutoRedactions()
    }

    @objc private func phoneNumbersRedactionDidChange() {
        updateAutoRedactions()
    }

    // MARK: Redacting

    func autoRedact() {
        let matchingObservations = matchingObservations(onlyActive: true)

        if matchingObservations.count > 0 {
            photoEditingView.redact(matchingObservations, joinSiblings: false)
            onRedact?()
        }
    }

    private func removeAutoRedactions() {
        matchingObservations(onlyActive: false).forEach(photoEditingView.unredact)
    }

    private func updateAutoRedactions() {
        // thisMeetingCouldHaveBeenAnEmail by @nutterfi on 2024-04-29
        // dontMailYourCats by @KaenAitch on 2024-04-29

        removeAutoRedactions()
        autoRedact()
    }

    // MARK: Matching

    /// Finds the observations that auto-redaction applies to.
    ///
    /// - Parameter characterObservations: The redactable character
    ///   observations to match against.
    /// - Parameter recognizedTextObservations: The recognized lines of text,
    ///   in reading order. Categories are detected across all of them
    ///   together, so each line has the others as context.
    /// - Parameter onlyActive: When `true`, only words and categories the
    ///   user has enabled are matched. When `false`, every word in the list
    ///   and every category is matched, so previous auto-redactions can be
    ///   removed regardless of their current settings.
    func matchingObservations(
        in characterObservations: [CharacterObservation],
        recognizedTextObservations: [RecognizedTextObservation],
        onlyActive: Bool
    ) -> [any TextObservation] {
        let wordObservations = tuBrute
            .filter { onlyActive ? $0.value : true }
            .keys
            .flatMap { word -> [CharacterObservation] in
                return characterObservations.matching(word)
            }
        var categories = [Detections.Category]()

        if autoRedactionsCategoryNames || onlyActive == false {
            categories.append(.names)
        }

        if autoRedactionsCategoryAddresses || onlyActive == false {
            categories.append(.addresses)
        }

        if autoRedactionsCategoryPhoneNumbers || onlyActive == false {
            categories.append(.phoneNumbers)
        }

        let combinedObservations = characterObservations.byUUID
            .values
            .compactMap(CombinedCharacterObservation.init)
        let combinedObservationsByUUID = Dictionary(
            combinedObservations.map { ($0.textObservationUUID, $0) },
            uniquingKeysWith: { first, _ in first }
        )

        // tag all recognized lines together, in reading order, so each line has the others as context
        let lines = recognizedTextObservations.map {
            TaggableLine(id: $0.textObservationUUID, text: $0.string)
        }
        let spansByLineAndCategory = Dictionary(grouping: Detections.Category.detections(for: categories, in: lines)) { span in
            LineCategory(lineID: span.lineID, category: span.category)
        }

        let categoryObservations = spansByLineAndCategory.compactMap { key, spans -> CharacterObservation? in
            guard let combinedObservation = combinedObservationsByUUID[key.lineID] else { return nil }
            let matchingObservations = combinedObservation.characterObservations(in: spans.map(\.range))
            guard matchingObservations.isEmpty == false else { return nil }
            let combinedShape = MinimumAreaShapeFinder.minimumAreaShape(for: matchingObservations.map(\.bounds))
            return CharacterObservation(bounds: combinedShape, textObservationUUID: combinedObservation.textObservationUUID)
        }

        return wordObservations + categoryObservations
    }

    private func matchingObservations(onlyActive: Bool) -> [any TextObservation] {
        matchingObservations(
            in: photoEditingView.redactableCharacterObservations,
            recognizedTextObservations: photoEditingView.recognizedTextObservations ?? [],
            onlyActive: onlyActive
        )
    }

    // MARK: Settings

    @Injected(\.defaults) private var defaults

    // tuBrute by @AdamWulf on 2024-04-29
    // the auto-redactions word list
    private var tuBrute: [String: Bool] {
        defaults.value(for: Keys.autoRedactionsSet) ?? [:]
    }
    private var autoRedactionsCategoryNames: Bool {
        defaults.value(for: Keys.autoRedactionsCategoryNames)
    }
    private var autoRedactionsCategoryAddresses: Bool {
        defaults.value(for: Keys.autoRedactionsCategoryAddresses)
    }
    private var autoRedactionsCategoryPhoneNumbers: Bool {
        defaults.value(for: Keys.autoRedactionsCategoryPhoneNumbers)
    }

    // MARK: Boilerplate

    private let photoEditingView: PhotoEditingScrollView
}

private struct LineCategory: Hashable {
    let lineID: UUID
    let category: Detections.Category
}
