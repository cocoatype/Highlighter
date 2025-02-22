//  Created by Geoff Pado on 2/22/25.
//  Copyright © 2025 Cocoatype, LLC. All rights reserved.

import Testing
import UIKit

@testable import Tools

struct PencilMenuInteractionPhaseTests {
    @available(iOS 17.5, *)
    @Test(arguments: [
        (UIPencilInteraction.Phase.began, PencilMenuInteractionPhase.began),
        (.changed, .changed),
        (.ended, .ended),
        (.cancelled, .cancelled),
    ])
    func initWithUIPencilInteractionPhase(uiKitPhase: UIPencilInteraction.Phase, expectedPhase: PencilMenuInteractionPhase) {
        #expect(PencilMenuInteractionPhase(uiKitPhase) == expectedPhase)
    }
}
