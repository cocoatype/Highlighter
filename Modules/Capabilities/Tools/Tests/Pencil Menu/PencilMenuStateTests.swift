//  Created by Geoff Pado on 2/22/25.
//  Copyright © 2025 Cocoatype, LLC. All rights reserved.

import Testing

@testable import Tools

struct PencilMenuStateTests {
    @Test(arguments: [
        (PencilMenuState.closed, false),
        (PencilMenuState.squeezed(next: .closed), true),
        (PencilMenuState.squeezed(next: .open), true),
        (PencilMenuState.open, true),
    ])
    func isOpen(state: PencilMenuState, expected: Bool) {
        #expect(state.isOpen == expected)
    }
}
