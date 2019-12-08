//  Created by Geoff Pado on 7/10/19.
//  Copyright © 2019 Cocoatype, LLC. All rights reserved.

import UIKit

public class EditingUserActivity: NSUserActivity {
    public init(assetLocalIdentifier: String? = nil, redactions: [Redaction]? = nil) {
        super.init(activityType: EditingUserActivity.defaultActivityType)
        title = EditingUserActivity.activityTitle
        self.assetLocalIdentifier = assetLocalIdentifier
        self.redactions = redactions
    }

    public convenience init?(userActivity: NSUserActivity) {
        guard userActivity.activityType == EditingUserActivity.defaultActivityType else { return nil }

        let assetLocalIdentifier = (userActivity.userInfo?[EditingUserActivity.assetLocalIdentifierKey] as? String)
        let redactionsData = (userActivity.userInfo?[EditingUserActivity.redactionsKey] as? [[Data]])
        let redactions = redactionsData?.compactMap(RedactionSerializer.redaction(from:))

        self.init(assetLocalIdentifier: assetLocalIdentifier, redactions: redactions)
        title = userActivity.title
    }

    public var assetLocalIdentifier: String?
    public var redactions: [Redaction]?

    public override var userInfo: [AnyHashable : Any]? {
        get {
            var userInfo = [AnyHashable: Any]()
            userInfo[EditingUserActivity.assetLocalIdentifierKey] = assetLocalIdentifier
            userInfo[EditingUserActivity.redactionsKey] = redactions?.map(RedactionSerializer.dataRepresentation(of:))

            return userInfo
        }
        set {}
    }

    // MARK: Boilerplate

    public static let assetLocalIdentifierKey = "EditingUserActivity.assetLocalIdentifierKey"
    public static let redactionsKey = "EditingUserActivity.redactionsKey"

    private static let defaultActivityType = "com.cocoatype.Highlighter.editing"
    private static let activityTitle = NSLocalizedString("EditingUserActivity.activityTitle", comment: "Title for the editing user activity")
}
