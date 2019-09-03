//  Created by Geoff Pado on 7/10/19.
//  Copyright © 2019 Cocoatype, LLC. All rights reserved.

import UIKit

public class EditingUserActivity: NSUserActivity {
    public init() {
        super.init(activityType: EditingUserActivity.defaultActivityType)
        title = EditingUserActivity.activityTitle
    }

    public convenience init(assetLocalIdentifier: String) {
        self.init()
        self.assetLocalIdentifier = assetLocalIdentifier
    }

    public var assetLocalIdentifier: String? {
        didSet { needsSave = true }
    }

    public override var userInfo: [AnyHashable : Any]? {
        get {
            var userInfo = [AnyHashable: Any]()
            userInfo[EditingUserActivity.assetLocalIdentifierKey] = assetLocalIdentifier
            return userInfo
        }
        set {}
    }

    // MARK: Boilerplate

    public static let assetLocalIdentifierKey = "EditingUserActivity.assetLocalIdentifierKey"

    private static let defaultActivityType = "com.cocoatype.Highlighter.editing"
    private static let activityTitle = NSLocalizedString("EditingUserActivity.activityTitle", comment: "Title for the editing user activity")
}
