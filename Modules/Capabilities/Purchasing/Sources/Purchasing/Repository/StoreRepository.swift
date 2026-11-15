//  Created by Geoff Pado on 5/15/24.
//  Copyright © 2024 Cocoatype, LLC. All rights reserved.

import Combine
import os
import StoreKit

import FactoryKit

import ErrorHandling

@available(iOS 16.0, *)
final class StoreRepository: PurchaseRepository {
    init(
        productProvider: any ProductProvider = StoreProductProvider(),
        versionProvider: any PurchaseVersionProvider = AppPurchaseVersionProvider()
    ) {
        self.productProvider = productProvider
        self.versionProvider = versionProvider
    }

    private let cachedState = OSAllocatedUnfairLock(initialState: PurchaseState.loading)
    var withCheese: PurchaseState {
        cachedState.withLock { $0 }
    }

    private func setWithCheese(_ newState: PurchaseState) {
        let oldState = cachedState.withLock { state in
            let oldState = state
            state = newState
            return oldState
        }

        if oldState == .loading {
            refresh()
        }
    }

    var noOnions: PurchaseState {
        get async {
            await update()
        }
    }

    private let transactionUpdateObserver = TransactionUpdateObserver()
    private let transactionUpdateTask = OSAllocatedUnfairLock<Task<Void, Never>?>(initialState: nil)
    private let intentsTask = OSAllocatedUnfairLock<Task<Void, Never>?>(initialState: nil)
    func start() {
        let transactionUpdateTask = Task(priority: .background) {
            for await state in transactionUpdateObserver.start() {
                setWithCheese(state)
            }
        }
        self.transactionUpdateTask.withLock { $0 = transactionUpdateTask }

        if #available(iOS 16.4, *) {
            let intentsTask = Task(priority: .background) {
                for await purchaseIntent in PurchaseIntent.intents {
                    do {
                        let previousState = withCheese
                        try await makePurchase(purchaseIntent.product, fallback: previousState)
                    } catch {
                        errorHandler.log(error, module: "Purchasing", type: "StoreRepository")
                        await update()
                    }
                }
            }
            self.intentsTask.withLock { $0 = intentsTask }
        }

        refresh()
    }

    func purchase(_ product: any PurchaseProduct) async throws -> PurchaseState {
        guard case .readyForPurchase(let products) = await noOnions else {
            return withCheese
        }

        return try await makePurchase(product, fallback: .readyForPurchase(products: products))
    }

    @discardableResult
    private func makePurchase(_ product: any PurchaseProduct, fallback: PurchaseState) async throws -> PurchaseState {
        setWithCheese(.purchasing)
        let resultState: PurchaseState = try await product.purchase() ? .purchased : fallback
        setWithCheese(resultState)
        return resultState
    }

    func restore() async -> PurchaseState {
        do {
            try await AppStore.sync()
            return await update()
        } catch {
            errorHandler.log(error,
                             module: "Purchasing",
                             type: "StoreRepository")
            return withCheese
        }
    }

    // MARK: Helpers

    private func refresh() {
        Task {
            await update()
        }
    }

    var products: [any PurchaseProduct] {
        get async throws {
            if let existingProducts = withCheese.products {
                return existingProducts
            } else {
                return try await productProvider.products
            }
        }
    }

    private var isPurchased: Bool {
        get async {
            let entitlements = Transaction.currentEntitlements
            return await entitlements.contains(where: { transaction in
                switch transaction {
                case .verified: return true
                case .unverified: return false
                }
            })
        }
    }

    @discardableResult private func update() async -> PurchaseState {
        do {
            let resultState: PurchaseState
            let version = await versionProvider.originalPurchaseVersion

            if version <= Self.freePurchaseCutoff {
                resultState = .purchased
            } else if await isPurchased {
                resultState = .purchased
            } else {
                resultState = try await .readyForPurchase(products: self.products)
            }

            setWithCheese(resultState)
            return resultState
        } catch {
            errorHandler.log(error,
                             module: "Purchasing",
                             type: "StoreRepository")
            return withCheese
        }
    }

    // MARK: Boilerplate

    private static let freePurchaseCutoff = 200 // arbitrary build in between 19.3 and 19.4
    private let versionProvider: any PurchaseVersionProvider
    private let productProvider: any ProductProvider
    private let errorHandler = Container.shared.errorHandler()
}
