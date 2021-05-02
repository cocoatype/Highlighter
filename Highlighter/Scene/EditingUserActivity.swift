//  Created by Geoff Pado on 7/10/19.
//  Copyright © 2019 Cocoatype, LLC. All rights reserved.

import UIKit

public class EditingUserActivity: NSUserActivity {
    public init(assetLocalIdentifier: String? = nil, imageBookmarkData: Data? = nil, redactions: [Redaction]? = nil) {
        super.init(activityType: EditingUserActivity.defaultActivityType)
        title = EditingUserActivity.activityTitle
        self.assetLocalIdentifier = assetLocalIdentifier
        self.imageBookmarkData = imageBookmarkData
        self.redactions = redactions
    }

    public convenience init?(userActivity: NSUserActivity) {
        guard userActivity.activityType == EditingUserActivity.defaultActivityType else { return nil }

        let assetLocalIdentifier = (userActivity.userInfo?[EditingUserActivity.assetLocalIdentifierKey] as? String)
        let imageBookmarkData = (userActivity.userInfo?[EditingUserActivity.imageBookmarkDataKey] as? Data)
        let redactionsData = (userActivity.userInfo?[EditingUserActivity.redactionsKey2] as? [Data])
        let redactions = redactionsData?.compactMap(RedactionSerializer.redaction(from:))

        let legacyRedactionsData = (userActivity.userInfo?[EditingUserActivity.redactionsKey] as? [[Data]])
        let legacyRedactions = legacyRedactionsData?.compactMap(RedactionSerializer.redaction(fromLegacyData:))

        self.init(assetLocalIdentifier: assetLocalIdentifier, imageBookmarkData: imageBookmarkData, redactions: redactions ?? legacyRedactions)
        title = userActivity.title
    }

    public var assetLocalIdentifier: String?
    public var imageBookmarkData: Data?
    public var redactions: [Redaction]?

    public override var userInfo: [AnyHashable : Any]? {
        get {
            var userInfo = [AnyHashable: Any]()
            userInfo[EditingUserActivity.assetLocalIdentifierKey] = assetLocalIdentifier
            userInfo[EditingUserActivity.imageBookmarkDataKey] = imageBookmarkData
            userInfo[EditingUserActivity.redactionsKey2] = redactions?.map(RedactionSerializer.dataRepresentation(of:))

            return userInfo
        }
        set {}
    }

    // MARK: Boilerplate

    public static let assetLocalIdentifierKey = "EditingUserActivity.assetLocalIdentifierKey"
    public static let imageBookmarkDataKey = "EditingUserActivity.imageBookmarkDataKey"
    public static let redactionsKey2 = "EditingUserActivity.redactionsKey2"
    public static let redactionsKey = "EditingUserActivity.redactionsKey"

    private static let defaultActivityType = "com.cocoatype.Highlighter.editing"
    private static let activityTitle = NSLocalizedString("EditingUserActivity.activityTitle", comment: "Title for the editing user activity")
}
