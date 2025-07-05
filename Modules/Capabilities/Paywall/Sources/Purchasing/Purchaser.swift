//  Created by Geoff Pado on 6/30/25.
//  Copyright © 2025 Cocoatype, LLC. All rights reserved.

import FactoryKit

import Logging
import Purchasing

struct Purchaser {
    private let eventBuilder = PurchaseEventBuilder()
    @Injected(\.logger) private var logger
    private let repository: any PurchaseRepository
    init(
        repository: any PurchaseRepository
    ) {
        self.repository = repository
    }

    func purchase(_ option: PaywallOption) async throws -> PurchaseState {
        let purchaseState = try await repository.purchase(option.product)
        let event = eventBuilder.startEvent(for: option)
        logger.log(event)

        return purchaseState
    }
}
