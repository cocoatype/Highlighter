//  Created by Geoff Pado on 5/15/24.
//  Copyright © 2024 Cocoatype, LLC. All rights reserved.

import Combine
import ErrorHandling
import StoreKit

@available(iOS 16.0, *)
final class StoreRepository: PurchaseRepository {
    init(
        productProvider: any ProductProvider = StoreProductProvider(),
        versionProvider: any PurchaseVersionProvider = AppPurchaseVersionProvider()
    ) {
        self.productProvider = productProvider
        self.versionProvider = versionProvider
    }

    @Published private(set) var withCheese: PurchaseState = .loading {
        didSet(newState) {
            if newState == .loading {
                refresh()
            }
        }
    }

    var noOnions: PurchaseState {
        get async {
            await update()
        }
    }

    private let transactionUpdateObserver = TransactionUpdateObserver()
    private var transactionUpdateTask: Task<Void, Never>?
    func start() {
        transactionUpdateTask = Task(priority: .background) {
            for await state in transactionUpdateObserver.start() {
                withCheese = state
            }
        }

        refresh()
    }

    func purchase() async -> PurchaseState {
        do {
            withCheese = .purchasing
            if try await product.purchase() {
                withCheese = .purchased
            }
            return withCheese
        } catch {
            ErrorHandler().log(error)
            return withCheese
        }
    }

    func restore() async -> PurchaseState {
        do {
            try await AppStore.sync()
            return await update()
        } catch {
            ErrorHandler().log(error)
            return withCheese
        }
    }

    // MARK: Helpers

    private func refresh() {
        Task {
            await update()
        }
    }

    private var product: any PurchaseProduct {
        get async throws {
            if let existingProduct = withCheese.product {
                return existingProduct
            } else {
                return try await productProvider.product
            }
        }
    }

    @discardableResult private func update() async -> PurchaseState {
        do {
            let resultState: PurchaseState
            let version = await versionProvider.originalPurchaseVersion

            if version <= Self.freePurchaseCutoff {
                resultState = .purchased
            } else {
                let product = try await self.product
                if await product.isPurchased {
                    resultState = .purchased
                } else {
                    resultState = .readyForPurchase(product: product)
                }
            }

            withCheese = resultState
            return resultState
        } catch {
            ErrorHandler().log(error)
            return withCheese
        }
    }

    // MARK: Boilerplate

    private static let freePurchaseCutoff = 200 // arbitrary build in between 19.3 and 19.4
    private let versionProvider: any PurchaseVersionProvider
    private let productProvider: any ProductProvider
}
