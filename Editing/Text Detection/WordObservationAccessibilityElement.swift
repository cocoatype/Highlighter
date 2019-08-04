//  Created by Geoff Pado on 8/4/19.
//  Copyright © 2019 Cocoatype, LLC. All rights reserved.

import UIKit

class WordObservationAccessibilityElement: UIAccessibilityElement {
    init(_ wordObservation: WordObservation, in workspaceView: PhotoEditingWorkspaceView) {
        self.wordObservation = wordObservation
        super.init(accessibilityContainer: workspaceView)

        accessibilityLabel = wordObservation.string
        accessibilityFrameInContainerSpace = wordObservation.bounds
    }

    override func accessibilityActivate() -> Bool {
        guard let workspaceView = workspaceView else { return false }
        workspaceView.redact(wordObservation)
        return true
    }

    private var wordObservation: WordObservation
    private var workspaceView: PhotoEditingWorkspaceView? { return accessibilityContainer as? PhotoEditingWorkspaceView }
}
