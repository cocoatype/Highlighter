//  Created by Geoff Pado on 12/4/24.
//  Copyright © 2024 Cocoatype, LLC. All rights reserved.

import SwiftUI
import Testing

import FactoryKit
import FactoryTesting
import ViewInspector

import LoggingDoubles

@testable import Unpurchased

@MainActor @Suite(.container)
struct UnpurchasedAlertViewModifierTests {
    @Test(arguments: [true, false])
    func presentationEventLog(isPresented: Bool) throws {
        let logger = SpyLogger()
        Container.shared.logger.register { logger }
        let modifier = UnpurchasedAlertViewModifier(
            for: .autoRedactions(),
            isPresented: .constant(false)
        )

        try modifier.inspect().viewModifierContent()
            .callOnChange(newValue: isPresented)

        let containsEvent = logger.loggedEvents.contains(where: {
            $0.name == "UnpurchasedAlertViewModifier.isPresented"
        })
        #expect(containsEvent == isPresented)
    }
}
