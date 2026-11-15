//  Created by Geoff Pado on 5/18/24.
//  Copyright © 2024 Cocoatype, LLC. All rights reserved.

public protocol PurchaseVersionProvider: Sendable {
    var originalPurchaseVersion: Int { get async }
}
