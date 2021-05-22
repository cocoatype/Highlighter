//  Created by Geoff Pado on 5/19/21.
//  Copyright © 2021 Cocoatype, LLC. All rights reserved.

import Foundation
import StoreKit

class RefreshReceiptsOperation: AsyncOperation<Void, Error>, SKRequestDelegate {
    override func start() {
        guard SKPaymentQueue.canMakePayments() else { fail(PurchaseOperationError.paymentsNotAvailable); return }
        let request = SKReceiptRefreshRequest()
        request.delegate = self
        request.start()
    }

    func requestDidFinish(_ request: SKRequest) {
        succeed()
    }

    func request(_ request: SKRequest, didFailWithError error: Error) {
        fail(error)
    }
}
