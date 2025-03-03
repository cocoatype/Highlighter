//  Created by Geoff Pado on 1/31/25.
//  Copyright © 2025 Cocoatype, LLC. All rights reserved.

public struct EventFactory {
    public init() {}

    public func editorPresentationEvent(for reason: EditorPresentationReason) -> Event {
        Event(
            name: "PhotoEditingNavigationController.isPresented",
            info: [
                "reason": reason.value
            ]
        )
    }
}
