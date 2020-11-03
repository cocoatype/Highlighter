//  Created by Geoff Pado on 10/28/20.
//  Copyright © 2020 Cocoatype, LLC. All rights reserved.

enum RedactActionExportError: Error {
    case failedToGenerateGraphicsContext
    case noImageForInput
    case operationReturnedNoResult
    case writeError
}
