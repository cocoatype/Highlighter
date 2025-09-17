//  Created by Geoff Pado on 7/26/24.
//  Copyright © 2024 Cocoatype, LLC. All rights reserved.

import Redactions
import UIKit

public enum SceneDependencies {
    case image(UIImage, [Redaction]?)
    case url(URL, [Redaction]?)
    case imageAndURL(UIImage, URL, [Redaction]?)
    case assetIdentifiers(String?, String?, [Redaction]?)

    init?(
        assetLocalIdentifier: String?,
        assetCloudIdentifier: String?,
        image: UIImage?,
        url: URL?,
        redactions: [Redaction]?
    ) {
        if assetLocalIdentifier != nil || assetCloudIdentifier != nil {
            self = .assetIdentifiers(assetLocalIdentifier, assetCloudIdentifier, redactions)
        } else {
            switch (image, url) {
            case (.some(let image), .some(let url)):
                self = .imageAndURL(image, url, redactions)
            case (.none, .some(let url)):
                self = .url(url, redactions)
            case (.some(let image), .none):
                self = .image(image, redactions)
            case (.none, .none):
                return nil
            }
        }
    }

    public var assetLocalIdentifier: String? {
        switch self {
        case .assetIdentifiers(let localID, _, _): localID
        case .image, .url, .imageAndURL: nil
        }
    }

    public var assetCloudIdentifier: String? {
        switch self {
        case .assetIdentifiers(_, let cloudID, _): cloudID
        case .image, .url, .imageAndURL: nil
        }
    }

    public var image: UIImage? {
        switch self {
        case .image(let image, _), .imageAndURL(let image, _, _): image
        case .assetIdentifiers, .url: nil
        }
    }

    public var representedURL: URL? {
        switch self {
        case .url(let url, _), .imageAndURL(_, let url, _): url
        case .assetIdentifiers, .image: nil
        }
    }

    public var redactions: [Redaction]? {
        switch self {
        case .image(_, let redactions): redactions
        case .url(_, let redactions): redactions
        case .imageAndURL(_, _, let redactions): redactions
        case .assetIdentifiers(_, _, let redactions): redactions
        }
    }
}
