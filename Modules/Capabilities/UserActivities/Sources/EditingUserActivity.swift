//  Created by Geoff Pado on 7/10/19.
//  Copyright © 2019 Cocoatype, LLC. All rights reserved.

import Photos
import UIKit

import PhotoAssets
import Redactions

public class EditingUserActivity: NSUserActivity {
    public init(
        assetLocalIdentifier: String? = nil,
        assetCloudIdentifier: String? = nil,
        imageBookmarkData: Data? = nil,
        imageData: Data? = nil,
        redactions: [Redaction]? = nil
    ) {
        super.init(activityType: EditingUserActivity.defaultActivityType)
        isEligibleForHandoff = true
        requiredUserInfoKeys = []
        title = UserActivitiesStrings.EditingUserActivity.activityTitle

        self.assetLocalIdentifier = assetLocalIdentifier
        self.assetCloudIdentifier = assetCloudIdentifier
        self.imageBookmarkData = imageBookmarkData
        self.imageData = imageData
        self.redactions = redactions

        self.userInfo = generatedUserInfo
    }

    public convenience init?(userActivity: NSUserActivity) {
        guard userActivity.activityType == EditingUserActivity.defaultActivityType else { return nil }

        let assetLocalIdentifier = (userActivity.userInfo?[EditingUserActivity.assetLocalIdentifierKey] as? String)
        let assetCloudIdentifier = (userActivity.userInfo?[EditingUserActivity.assetCloudIdentifierKey] as? String)
        let imageBookmarkData = (userActivity.userInfo?[EditingUserActivity.imageBookmarkDataKey] as? Data)
        let imageData = (userActivity.userInfo?[EditingUserActivity.imageDataKey] as? Data)
        let redactionsData = (userActivity.userInfo?[EditingUserActivity.redactionsKey2] as? [Data])
        let redactions = redactionsData?.compactMap(RedactionSerializer.redaction(from:))

        let legacyRedactionsData = (userActivity.userInfo?[EditingUserActivity.redactionsKey] as? [[Data]])
        let legacyRedactions = legacyRedactionsData?.compactMap(RedactionSerializer.redaction(fromLegacyData:))

        self.init(
            assetLocalIdentifier: assetLocalIdentifier,
            assetCloudIdentifier: assetCloudIdentifier,
            imageBookmarkData: imageBookmarkData,
            imageData: imageData,
            redactions: redactions ?? legacyRedactions
        )
        isEligibleForHandoff = userActivity.isEligibleForHandoff
        title = userActivity.title
    }

    public private(set) var assetLocalIdentifier: String?
    public private(set) var assetCloudIdentifier: String?
    public var imageBookmarkData: Data? { didSet { userInfo = generatedUserInfo }}
    public var imageData: Data? { didSet { userInfo = generatedUserInfo }}
    public var redactions: [Redaction]? { didSet { userInfo = generatedUserInfo }}

    private var generatedUserInfo: [AnyHashable: Any] {
        var userInfo = [AnyHashable: Any]()
        userInfo[EditingUserActivity.assetLocalIdentifierKey] = assetLocalIdentifier
        userInfo[EditingUserActivity.assetCloudIdentifierKey] = assetCloudIdentifier
        userInfo[EditingUserActivity.imageBookmarkDataKey] = imageBookmarkData
        userInfo[EditingUserActivity.imageDataKey] = imageData
        userInfo[EditingUserActivity.redactionsKey2] = redactions?.map(RedactionSerializer.dataRepresentation(of:))

        return userInfo
    }

    // MARK: Asset

    private let mapper = PhotoAssetsCloudIdentifierMapper()
    public func setIdentifiers(for asset: PHAsset) {
        assetLocalIdentifier = asset.localIdentifier
        assetCloudIdentifier = mapper.cloudIdentifier(for: asset.localIdentifier)

        userInfo = generatedUserInfo
    }

    // MARK: Image

    public var image: UIImage? {
        get {
            guard let data = imageData else { return nil }
            return UIImage(data: data)
        } set(newImage) {
            imageData = newImage?.pngData()
        }
    }

    // MARK: URL

    public var representedURL: URL? {
        var isStale = false
        guard let bookmarkData = imageBookmarkData,
              let url = try? URL(resolvingBookmarkData: bookmarkData, bookmarkDataIsStale: &isStale),
              FileManager.default.fileExists(atPath: url.path),
              let cachesDirectory = try? FileManager.default.url(for: .cachesDirectory, in: .userDomainMask, appropriateFor: nil, create: false),
              cachesDirectory.isParent(of: url) == false
        else { return nil }
        return url
    }

    // MARK: Boilerplate

    public static let assetLocalIdentifierKey = "EditingUserActivity.assetLocalIdentifierKey"
    public static let assetCloudIdentifierKey = "EditingUserActivity.assetCloudIdentifierKey"
    public static let imageBookmarkDataKey = "EditingUserActivity.imageBookmarkDataKey"
    public static let imageDataKey = "EditingUserActivity.imageDataKey"
    public static let redactionsKey2 = "EditingUserActivity.redactionsKey2"
    public static let redactionsKey = "EditingUserActivity.redactionsKey"

    public static let defaultActivityType = "com.cocoatype.Highlighter.editing"
}
