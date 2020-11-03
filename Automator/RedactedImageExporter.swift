//  Created by Geoff Pado on 10/28/20.
//  Copyright © 2020 Cocoatype, LLC. All rights reserved.

import AppKit
import Redacting

class RedactActionExporter: NSObject {
    static func export(_ input: RedactActionInput, redactions: [Redaction], completionHandler: @escaping((Result<String, Error>) -> Void)) {
        let exportOperation = RedactActionExportOperation(input: input, redactions: redactions)
        let callbackOperation = BlockOperation {
            guard let result = exportOperation.result else {
                return completionHandler(.failure(RedactActionExportError.operationReturnedNoResult))
            }

            completionHandler(result)
        }

        callbackOperation.addDependency(exportOperation)
        operationQueue.addOperations([exportOperation, callbackOperation], waitUntilFinished: false)
    }

    private static let operationQueue = OperationQueue()
}
