//  Created by Geoff Pado on 3/3/25.
//  Copyright © 2025 Cocoatype, LLC. All rights reserved.

import UIKit

class PhotoPermissionsAlertAction: UIAlertAction {
    var handler: ((UIAlertAction) -> Void)?
    class func action(
        title: String,
        style: UIAlertAction.Style,
        handlerBody: (() -> Void)?
    ) -> PhotoPermissionsAlertAction {
        let handler: ((UIAlertAction) -> Void)?
        if let handlerBody {
            handler = { _ in handlerBody() }
        } else {
            handler = nil
        }

        let alertAction = self.init(title: title, style: style, handler: handler)
        alertAction.handler = handler
        return alertAction
    }
}
