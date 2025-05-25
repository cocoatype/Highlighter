//  Created by Geoff Pado on 12/4/24.
//  Copyright © 2024 Cocoatype, LLC. All rights reserved.

import LoggingDoubles
import SwiftUI
import ViewInspector
import Testing

@testable import Unpurchased

@MainActor struct UnpurchasedAlertViewModifierTests {
    @Test func whenIsPresentedTrueThenEventLogged() throws {
        let logger = SpyLogger()
        let modifier = UnpurchasedAlertViewModifier(for: .autoRedactions(), isPresented: .constant(false), logger: logger)

        try modifier.inspect().viewModifierContent().callOnChange(newValue: true)

        #expect(logger.loggedEvents.contains(where: { $0.name == "UnpurchasedAlertViewModifier.isPresented" }) == true)
    }

    @Test func whenIsPresentedFalseThenEventNotLogged() throws {
        let logger = SpyLogger()
        let modifier = UnpurchasedAlertViewModifier(for: .autoRedactions(), isPresented: .constant(false), logger: logger)

        try modifier.inspect().viewModifierContent().callOnChange(newValue: false)

        #expect(logger.loggedEvents.contains(where: { $0.name == "UnpurchasedAlertViewModifier.isPresented" }) == false)
    }
}
