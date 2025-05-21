//  Created by Geoff Pado on 2/22/25.
//  Copyright © 2025 Cocoatype, LLC. All rights reserved.

import UIKit

class UnpurchasedAlertAction: UIAlertAction {
    var action: (() -> Void)?
    class func action(
        title: String,
        style: UIAlertAction.Style,
        action: @escaping @MainActor () -> Void
    ) -> UnpurchasedAlertAction {
        let alertAction = self.init(title: title, style: style) { _ in
            action()
        }
        alertAction.action = action
        return alertAction
    }
}
