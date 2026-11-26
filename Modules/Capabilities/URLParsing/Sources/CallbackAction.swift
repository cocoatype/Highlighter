//  Created by Geoff Pado on 5/29/19.
//  Copyright © 2019 Cocoatype, LLC. All rights reserved.

#if canImport(UIKit)
import UIKit
#else
import Foundation
#endif

public enum CallbackAction {
    #if canImport(UIKit)
    case edit(UIImage, URL?)
    case open(UIImage)

    public var image: UIImage {
        switch self {
        case .edit(let image, _): return image
        case .open(let image): return image
        }
    }

    init?(url: URL) {
        guard let components = URLComponents(url: url, resolvingAgainstBaseURL: true),
            let host = components.host,
            host == "x-callback-url",
            let queryItems = components.queryItems,
            let imageDataItem = queryItems.first(where: { $0.name == "imageData" }),
            let imageDataString = imageDataItem.value,
            let imageData = Data(base64Encoded: imageDataString),
            let image = UIImage(data: imageData)
            else { return nil }

        if url.path == "/edit" {
            let successURLItem = queryItems.first(where: { $0.name == "x-success" })
            let successURLEncodedString = successURLItem?.value
            let successURL: URL?
            if let successURLString = successURLEncodedString?.removingPercentEncoding {
                successURL = URL(string: successURLString)
            } else {
                successURL = nil
            }

            self = .edit(image, successURL)
        } else if url.path == "/open" {
            self = .open(image)
        } else {
            return nil
        }
    }
    #else
    init?(url: URL) { return nil }
    #endif
}
