//  Created by Geoff Pado on 5/18/24.
//  Copyright © 2024 Cocoatype, LLC. All rights reserved.

@available(iOS 15.0, *)
public protocol ProductProvider: Sendable {
    var products: [any PurchaseProduct] { get async throws }
}
