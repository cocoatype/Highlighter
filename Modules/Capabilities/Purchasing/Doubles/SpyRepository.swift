//  Created by Geoff Pado on 5/16/24.
//  Copyright © 2024 Cocoatype, LLC. All rights reserved.

import Combine
import Purchasing
import TestHelpersInterface

public struct SpyRepository: PurchaseRepository {
    public init(
        withCheese: PurchaseState = .loading,
        noOnions: PurchaseState = .loading,
        products: [any PurchaseProduct] = [],
        startExpectation: Expectation? = nil,
        purchaseExpectation: Expectation? = nil,
        purchaseResponse: PurchaseState = .loading,
        restoreExpectation: Expectation? = nil,
        restoreResponse: PurchaseState = .loading,
        productsError: (any Error)? = nil,
        purchaseError: (any Error)? = nil
    ) {
        self.withCheese = withCheese
        self.noOnions = noOnions
        self.storedProducts = products
        self.productsError = productsError
        self.purchaseError = purchaseError
        self.startExpectation = startExpectation
        self.purchaseExpectation = purchaseExpectation
        self.purchaseResponse = purchaseResponse
        self.restoreExpectation = restoreExpectation
        self.restoreResponse = restoreResponse
    }

    public var withCheese: PurchaseState = .loading
    public var noOnions: PurchaseState = .loading
    public var storedProducts: [any PurchaseProduct] = []
    public var productsError: (any Error)?
    public var products: [any PurchaseProduct] {
        get throws {
            if let productsError { throw productsError }
            return storedProducts
        }
    }

    public var startExpectation: Expectation?
    public func start() {
        startExpectation?.fulfill()
    }

    public var purchaseExpectation: Expectation?
    public var purchaseResponse: PurchaseState = .loading
    public var purchaseError: (any Error)?
    public func purchase(_ product: any PurchaseProduct) async throws -> PurchaseState {
        purchaseExpectation?.fulfill()
        if let purchaseError { throw purchaseError }
        return purchaseResponse
    }

    public var restoreExpectation: Expectation?
    public var restoreResponse: PurchaseState = .loading
    public func restore() async -> PurchaseState {
        restoreExpectation?.fulfill()
        return restoreResponse
    }
}
