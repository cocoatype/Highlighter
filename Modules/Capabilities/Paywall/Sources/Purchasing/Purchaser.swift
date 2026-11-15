//  Created by Geoff Pado on 6/30/25.
//  Copyright © 2025 Cocoatype, LLC. All rights reserved.

import FactoryKit

import Logging
import Purchasing

struct Purchaser {
    private let eventBuilder = PurchaseEventBuilder()
    @Injected(\.logger) private var logger
    @Injected(\.purchaseRepository) private var repository

    func purchase(_ option: PaywallOption) async throws -> PurchaseState {
        // log before purchasing, so attempts that throw still count as started
        logger.log(eventBuilder.startEvent(for: option))
        return try await repository.purchase(option.product)
    }
}
