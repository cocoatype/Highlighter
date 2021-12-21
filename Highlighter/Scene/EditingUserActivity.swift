//  Created by Geoff Pado on 7/10/19.
//  Copyright © 2019 Cocoatype, LLC. All rights reserved.

import UIKit

public class EditingUserActivity: NSUserActivity {
    public init(assetLocalIdentifier: String? = nil, imageBookmarkData: Data? = nil, imageData: Data? = nil, redactions: [Redaction]? = nil) {
        super.init(activityType: EditingUserActivity.defaultActivityType)
        title = EditingUserActivity.activityTitle
        self.assetLocalIdentifier = assetLocalIdentifier
        self.imageBookmarkData = imageBookmarkData
        self.imageData = imageData
        self.redactions = redactions

        self.userInfo = generatedUserInfo
    }

    public convenience init?(userActivity: NSUserActivity) {
        guard userActivity.activityType == EditingUserActivity.defaultActivityType else { return nil }

        let assetLocalIdentifier = (userActivity.userInfo?[EditingUserActivity.assetLocalIdentifierKey] as? String)
        let imageBookmarkData = (userActivity.userInfo?[EditingUserActivity.imageBookmarkDataKey] as? Data)
        let imageData = (userActivity.userInfo?[EditingUserActivity.imageDataKey] as? Data)
        let redactionsData = (userActivity.userInfo?[EditingUserActivity.redactionsKey2] as? [Data])
        let redactions = redactionsData?.compactMap(RedactionSerializer.redaction(from:))

        let legacyRedactionsData = (userActivity.userInfo?[EditingUserActivity.redactionsKey] as? [[Data]])
        let legacyRedactions = legacyRedactionsData?.compactMap(RedactionSerializer.redaction(fromLegacyData:))

        self.init(assetLocalIdentifier: assetLocalIdentifier, imageBookmarkData: imageBookmarkData, imageData: imageData, redactions: redactions ?? legacyRedactions)
        title = userActivity.title
    }

    public var assetLocalIdentifier: String? { didSet { userInfo = generatedUserInfo }}
    public var imageBookmarkData: Data? { didSet { userInfo = generatedUserInfo }}
    public var imageData: Data? { didSet { userInfo = generatedUserInfo }}
    public var redactions: [Redaction]? { didSet { userInfo = generatedUserInfo }}

    private var generatedUserInfo: [AnyHashable: Any] {
        var userInfo = [AnyHashable: Any]()
        userInfo[EditingUserActivity.assetLocalIdentifierKey] = assetLocalIdentifier
        userInfo[EditingUserActivity.imageBookmarkDataKey] = imageBookmarkData
        userInfo[EditingUserActivity.imageDataKey] = imageData
        userInfo[EditingUserActivity.redactionsKey2] = redactions?.map(RedactionSerializer.dataRepresentation(of:))

        return userInfo
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

    // MARK: Boilerplate

    public static let assetLocalIdentifierKey = "EditingUserActivity.assetLocalIdentifierKey"
    public static let imageBookmarkDataKey = "EditingUserActivity.imageBookmarkDataKey"
    public static let imageDataKey = "EditingUserActivity.imageDataKey"
    public static let redactionsKey2 = "EditingUserActivity.redactionsKey2"
    public static let redactionsKey = "EditingUserActivity.redactionsKey"

    public static let defaultActivityType = "com.cocoatype.Highlighter.editing"
    private static let activityTitle = NSLocalizedString("EditingUserActivity.activityTitle", comment: "Title for the editing user activity")
}
