//  Created by Geoff Pado on 8/4/19.
//  Copyright © 2019 Cocoatype, LLC. All rights reserved.

import UIKit

class WordObservationAccessibilityElement: UIAccessibilityElement {
    init(_ wordObservation: WordObservation, in workspaceView: PhotoEditingWorkspaceView, onActivate: @escaping (WordObservation, Bool) -> Bool) {
        self.wordObservation = wordObservation
        self.onActivate = onActivate
        super.init(accessibilityContainer: workspaceView)

        accessibilityLabel = wordObservation.string
        accessibilityFrameInContainerSpace = wordObservation.bounds.boundingBox
        accessibilityTraits = .button
        accessibilityValue = isRedacted ? Self.redactedValue : nil
    }

    private let onActivate: (WordObservation, Bool) -> Bool
    override func accessibilityActivate() -> Bool {
        return onActivate(wordObservation, isRedacted)
    }

    private let wordObservation: WordObservation
    private var workspaceView: PhotoEditingWorkspaceView? { return accessibilityContainer as? PhotoEditingWorkspaceView }

    private static let redactedValue = NSLocalizedString("WordObservationAccessibilityElement.redactedValue", comment: "Redacted accessibility value")

    var isRedacted: Bool {
        guard let workspaceView = workspaceView
        else { return false }

        return workspaceView.redactions.contains(where: { existingRedaction in
            let sampleRedaction = Redaction(wordObservation, color: existingRedaction.color)
            return existingRedaction == sampleRedaction
        })
    }

    static func == (lhs: WordObservationAccessibilityElement, rhs: WordObservationAccessibilityElement) -> Bool {
        lhs.wordObservation.textObservationUUID == rhs.wordObservation.textObservationUUID
    }
}
