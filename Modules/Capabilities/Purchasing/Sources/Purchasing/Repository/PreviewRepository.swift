//  Created by Geoff Pado on 7/9/25.
//  Copyright © 2025 Cocoatype, LLC. All rights reserved.

struct PreviewRepository: PurchaseRepository {
    var withCheese: PurchaseState { .unavailable }

    var noOnions: PurchaseState { withCheese }

    var products: [any PurchaseProduct] { [] }

    func start() {}

    func purchase(_ product: any PurchaseProduct) async throws -> PurchaseState {
        withCheese
    }

    func restore() async -> PurchaseState {
        withCheese
    }
}
