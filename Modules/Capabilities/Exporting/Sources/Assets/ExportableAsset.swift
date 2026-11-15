//  Created by Geoff Pado on 12/5/24.
//  Copyright © 2024 Cocoatype, LLC. All rights reserved.

import Photos

protocol ExportableAsset: Sendable {
    func requestContentEditingInput(with options: PHContentEditingInputRequestOptions?) async -> (PHContentEditingInput?, [AnyHashable: Any])

    var changeRequest: PHAssetChangeRequest { get }
}

extension PHAsset: ExportableAsset {
    public func requestContentEditingInput(with options: PHContentEditingInputRequestOptions?) async -> (PHContentEditingInput?, [AnyHashable: Any]) {
        await withCheckedContinuation { continuation in
            requestContentEditingInput(with: options) { input, info in
                // Photos hands these to the completion handler and doesn't use them
                // afterward, so it's safe to transfer them to the awaiting task.
                nonisolated(unsafe) let result = (input, info)
                continuation.resume(returning: result)
            }
        }
    }

    public var changeRequest: PHAssetChangeRequest {
        PHAssetChangeRequest(for: self)
    }
}

enum ExportableAssetError: Error {
    case unexpectedNil
}
