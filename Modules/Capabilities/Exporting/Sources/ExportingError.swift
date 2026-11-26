//  Created by Geoff Pado on 7/1/24.
//  Copyright © 2024 Cocoatype, LLC. All rights reserved.

enum ExportingError: Error {
    case missingBundleVersion
    case noDataGenerated
    case noInputProvided
    case failedImageDecode
    case failedImageEncode
    case unexpectedHEIC
    case unexpectedEncodeType(String)
}
