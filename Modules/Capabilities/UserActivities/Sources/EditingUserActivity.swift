//  Created by Geoff Pado on 7/10/19.
//  Copyright © 2019 Cocoatype, LLC. All rights reserved.

import Photos
import UIKit

import FactoryKit

import ErrorHandling
import PhotoAssets
import Redactions

public class EditingUserActivity: NSUserActivity {
    public init(
        assetLocalIdentifier: String? = nil,
        assetCloudIdentifier: String? = nil,
        imageBookmarkData: Data? = nil,
        redactions: [Redaction]? = nil
    ) {
        super.init(activityType: EditingUserActivity.defaultActivityType)
        isEligibleForHandoff = true
        requiredUserInfoKeys = []
        title = UserActivitiesStrings.EditingUserActivity.activityTitle

        self.assetLocalIdentifier = assetLocalIdentifier
        self.assetCloudIdentifier = assetCloudIdentifier
        self.imageBookmarkData = imageBookmarkData
        self.redactions = redactions

        self.userInfo = generatedUserInfo

        loadImage()
    }

    public convenience init?(userActivity: NSUserActivity) {
        guard userActivity.activityType == EditingUserActivity.defaultActivityType else { return nil }

        let assetLocalIdentifier = (userActivity.userInfo?[EditingUserActivity.assetLocalIdentifierKey] as? String)
        let assetCloudIdentifier = (userActivity.userInfo?[EditingUserActivity.assetCloudIdentifierKey] as? String)
        let imageBookmarkData = (userActivity.userInfo?[EditingUserActivity.imageBookmarkDataKey] as? Data)
        let redactionsData = (userActivity.userInfo?[EditingUserActivity.redactionsKey2] as? [Data])
        let redactions = redactionsData?.compactMap(RedactionSerializer.redaction(from:))

        let legacyRedactionsData = (userActivity.userInfo?[EditingUserActivity.redactionsKey] as? [[Data]])
        let legacyRedactions = legacyRedactionsData?.compactMap(RedactionSerializer.redaction(fromLegacyData:))

        self.init(
            assetLocalIdentifier: assetLocalIdentifier,
            assetCloudIdentifier: assetCloudIdentifier,
            imageBookmarkData: imageBookmarkData,
            redactions: redactions ?? legacyRedactions
        )
        isEligibleForHandoff = userActivity.isEligibleForHandoff
        title = userActivity.title
    }

    public private(set) var assetLocalIdentifier: String?
    public private(set) var assetCloudIdentifier: String?
    public var imageBookmarkData: Data? { didSet { userInfo = generatedUserInfo }}
    public var redactions: [Redaction]? { didSet { userInfo = generatedUserInfo }}

    private var generatedUserInfo: [AnyHashable: Any] {
        var userInfo = [AnyHashable: Any]()
        userInfo[EditingUserActivity.assetLocalIdentifierKey] = assetLocalIdentifier
        userInfo[EditingUserActivity.assetCloudIdentifierKey] = assetCloudIdentifier
        userInfo[EditingUserActivity.imageBookmarkDataKey] = imageBookmarkData
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

    public private(set) var image: UIImage?

    private func loadImage() {
        guard image == nil, let representedURL else { return }

        let accessGranted = representedURL.startAccessingSecurityScopedResource()
        defer { representedURL.stopAccessingSecurityScopedResource() }
        guard accessGranted else { return }

        do {
            let data = try Data(contentsOf: representedURL)
            self.image = UIImage(data: data)
        } catch {
            errorHandler.log(error, module: "UserActivities", type: "EditingUserActivity")
        }
    }

    // MARK: URL

    public var representedURL: URL? {
        do {
            var isStale = false
            guard let imageBookmarkData else { return nil }
            let url = try URL(resolvingBookmarkData: imageBookmarkData, bookmarkDataIsStale: &isStale)

            if isStale {
                do {
                    #if targetEnvironment(macCatalyst)
                    let options = URL.BookmarkCreationOptions.withSecurityScope
                    #else
                    let options: URL.BookmarkCreationOptions = []
                    #endif

                    let newBookmarkData = try url.bookmarkData(options: options)
                    self.imageBookmarkData = newBookmarkData
                } catch {
                    errorHandler.log(error, module: "UserActivities", type: "EditingUserActivity")
                    return url
                }
            }

            return url
        } catch {
            errorHandler.log(error, module: "UserActivities", type: "EditingUserActivity")
            return nil
        }
    }

    // MARK: Boilerplate

    @Injected(\.errorHandler) private var errorHandler

    public static let assetLocalIdentifierKey = "EditingUserActivity.assetLocalIdentifierKey"
    public static let assetCloudIdentifierKey = "EditingUserActivity.assetCloudIdentifierKey"
    public static let imageBookmarkDataKey = "EditingUserActivity.imageBookmarkDataKey"
    public static let redactionsKey2 = "EditingUserActivity.redactionsKey2"
    public static let redactionsKey = "EditingUserActivity.redactionsKey"

    public static let defaultActivityType = "com.cocoatype.Highlighter.editing"
}
