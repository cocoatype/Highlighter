//  Created by Geoff Pado on 5/15/24.
//  Copyright © 2024 Cocoatype, LLC. All rights reserved.

import Combine
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

    func purchase(_ product: any PurchaseProduct) async throws -> PurchaseState {
        guard case .readyForPurchase(let products) = await noOnions else {
            return withCheese
        }

        withCheese = .purchasing
        if try await product.purchase() {
            withCheese = .purchased
        } else {
            withCheese = .readyForPurchase(products: products)
        }
        return withCheese
    }

    func restore() async -> PurchaseState {
        do {
            try await AppStore.sync()
            return await update()
        } catch {
            errorHandler.log(error)
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

            withCheese = resultState
            return resultState
        } catch {
            errorHandler.log(error)
            return withCheese
        }
    }

    // MARK: Boilerplate

    private static let freePurchaseCutoff = 200 // arbitrary build in between 19.3 and 19.4
    private let versionProvider: any PurchaseVersionProvider
    private let productProvider: any ProductProvider
    @Injected(\.errorHandler) private var errorHandler
}
