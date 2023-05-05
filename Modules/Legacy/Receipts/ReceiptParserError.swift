//  Created by Geoff Pado on 8/18/19.
//  Copyright © 2019 Cocoatype, LLC. All rights reserved.

enum ReceiptParserError: Error {
    case malformedReceipt
    case incompleteData
    case invalidReceipt
}
