//  Created by Geoff Pado on 8/18/19.
//  Copyright © 2019 Cocoatype, LLC. All rights reserved.

import Foundation

public struct AppReceipt {
    let bundleIdentifier: String
    let bundleIdentifierData: Data
    let appVersion: String
    let opaqueValue: Data
    let sha1Hash: Data
    public let purchaseReceipts: [PurchaseReceipt]
    let originalAppVersion: String?
    let receiptCreationDate: Date?
    let expirationDate: Date?

    public var purchaseVersion: String { return originalAppVersion ?? appVersion }

    init(bundleIdentifier: String?, bundleIdentifierData: Data?, appVersion: String?, opaqueValue: Data?, sha1Hash: Data?, purchaseReceipts: [PurchaseReceipt], originalAppVersion: String?, receiptCreationDate: Date?, expirationDate: Date?) throws {
        guard
          let bundleIdentifier = bundleIdentifier,
          let bundleIdentifierData = bundleIdentifierData,
          let appVersion = appVersion,
          let opaqueValue = opaqueValue,
          let sha1Hash = sha1Hash
        else { throw ReceiptParserError.incompleteData } // checking required values

        self.bundleIdentifier = bundleIdentifier
        self.bundleIdentifierData = bundleIdentifierData
        self.appVersion = appVersion
        self.opaqueValue = opaqueValue
        self.sha1Hash = sha1Hash
        self.purchaseReceipts = purchaseReceipts
        self.originalAppVersion = originalAppVersion
        self.receiptCreationDate = receiptCreationDate
        self.expirationDate = expirationDate
    }

    public func containsPurchase(withIdentifier identifier: String) -> Bool {
        return purchaseReceipts.contains(where: { $0.productIdentifier == identifier })
    }
}
