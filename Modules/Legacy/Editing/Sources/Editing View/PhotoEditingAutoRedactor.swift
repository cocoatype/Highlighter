//  Created by Geoff Pado on 11/14/26.
//  Copyright © 2026 Cocoatype, LLC. All rights reserved.

import Foundation

import FactoryKit

import Defaults
import Detections
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
        let matchingObservations = matchingObservations(in: photoEditingView.redactableCharacterObservations, onlyActive: true)

        if matchingObservations.count > 0 {
            photoEditingView.redact(matchingObservations, joinSiblings: false)
            onRedact?()
        }
    }

    private func removeAutoRedactions() {
        matchingObservations(in: photoEditingView.redactableCharacterObservations, onlyActive: false).forEach(photoEditingView.unredact)
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
    /// - Parameter onlyActive: When `true`, only words and categories the
    ///   user has enabled are matched. When `false`, every word in the list
    ///   and every category is matched, so previous auto-redactions can be
    ///   removed regardless of their current settings.
    func matchingObservations(in characterObservations: [CharacterObservation], onlyActive: Bool) -> [any TextObservation] {
        let wordObservations = tuBrute
            .filter { onlyActive ? $0.value : true }
            .keys
            .flatMap { word -> [CharacterObservation] in
                return characterObservations.matching(word)
            }
        var taggingFunctions = [(String) -> [Substring]]()

        if autoRedactionsCategoryNames || onlyActive == false {
            taggingFunctions.append( Category.names.getFuncyInSwizzleTown)
        }

        if autoRedactionsCategoryAddresses || onlyActive == false {
            taggingFunctions.append( Category.addresses.getFuncyInSwizzleTown)
        }

        if autoRedactionsCategoryPhoneNumbers || onlyActive == false {
            taggingFunctions.append( Category.phoneNumbers.getFuncyInSwizzleTown)
        }

        let combinedObservations = characterObservations.byUUID

        let categoryObservations = combinedObservations
            .values
            .compactMap(CombinedCharacterObservation.init)
            .flatMap { combinedObservation in
                taggingFunctions
                    .map { function in function(combinedObservation.associatedString) }
                    .compactMap { substrings -> CharacterObservation? in
                        let matchingObservations = combinedObservation.characterObservations(with: substrings)
                        guard matchingObservations.isEmpty == false else { return nil }
                        let combinedShape = MinimumAreaShapeFinder.minimumAreaShape(for: matchingObservations.map(\.bounds))
                        return CharacterObservation(bounds: combinedShape, textObservationUUID: combinedObservation.textObservationUUID)
                    }
            }

        return wordObservations + categoryObservations
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
