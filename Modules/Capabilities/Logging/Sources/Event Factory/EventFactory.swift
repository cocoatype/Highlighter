//  Created by Geoff Pado on 1/31/25.
//  Copyright © 2025 Cocoatype, LLC. All rights reserved.

public struct EventFactory {
    public init() {}

    public func editorPresentationEvent(
        for reason: EditorPresentationReason
    ) -> Event {
        presentationEvent(
            name: "PhotoEditingNavigationController.isPresented",
            reason: reason
        )
    }

    public func scannerPresentationEvent(
        for reason: ScannerPresentationReason
    ) -> Event {
        presentationEvent(
            name: "DocumentCameraViewController.isPresented",
            reason: reason
        )
    }

    private func presentationEvent(
        name: Event.Name,
        reason: any PresentationReason
    ) -> Event {
        Event(
            name: name,
            info: [
                "reason": reason.value
            ]
        )
    }
}
