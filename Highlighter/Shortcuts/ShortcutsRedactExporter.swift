//  Created by Geoff Pado on 11/6/20.
//  Copyright © 2020 Cocoatype, LLC. All rights reserved.

import Editing
import Intents

@available(iOS 14.0, *)
class ShortcutsRedactExporter: NSObject {
    static func export(_ input: INFile, redactions: [Redaction], completionHandler: @escaping((Result<INFile, Error>) -> Void)) {
        let exportOperation = ShortcutsExportOperation(input: input, redactions: redactions)
        let callbackOperation = BlockOperation {
            guard let result = exportOperation.result else {
                return completionHandler(.failure(ShortcutsExportError.operationReturnedNoResult))
            }

            completionHandler(result)
        }

        callbackOperation.addDependency(exportOperation)
        operationQueue.addOperations([exportOperation, callbackOperation], waitUntilFinished: false)
    }

    private static let operationQueue = OperationQueue()
}
