//  Created by Geoff Pado on 8/12/19.
//  Copyright © 2019 Cocoatype, LLC. All rights reserved.

import UIKit

struct AutoRedactionsItem: StandardContentItem {
    let title = NSLocalizedString("SettingsContentProvider.Item.autoRedactions", comment: "Title for the auto redactions settings item")
    func performSelectedAction(_ sender: Any) {
        UIApplication.shared.sendAction(#selector(SettingsNavigationController.presentAutoRedactionsEditViewController), to: nil, from: sender, for: nil)
    }
}
