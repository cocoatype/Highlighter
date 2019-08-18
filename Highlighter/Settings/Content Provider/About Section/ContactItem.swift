//  Created by Geoff Pado on 8/12/19.
//  Copyright © 2019 Cocoatype, LLC. All rights reserved.

import UIKit

struct ContactItem: StandardContentItem {
    let title = NSLocalizedString("SettingsContentProvider.Item.contact", comment: "Title for the contact settings item")
    func performSelectedAction(_ sender: Any) {
        UIApplication.shared.sendAction(#selector(SettingsNavigationController.presentContactViewController), to: nil, from: sender, for: nil)
    }
}
