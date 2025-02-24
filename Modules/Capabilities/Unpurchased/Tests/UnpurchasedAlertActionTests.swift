//  Created by Geoff Pado on 2/23/25.
//  Copyright © 2025 Cocoatype, LLC. All rights reserved.

import Testing

@testable import Unpurchased

struct UnpurchasedAlertActionTests {
    @MainActor @Test
    func creatingActionSavesHandler() async throws {
        try await confirmation { handlerCalled in
            let action = UnpurchasedAlertAction.action(title: "", style: .default) {
                handlerCalled()
            }
            let handler = try #require(action.action)
            handler()
        }
    }
}
