//  Created by Geoff Pado on 8/12/19.
//  Copyright © 2019 Cocoatype, LLC. All rights reserved.

import UIKit

struct PrivacyItem: StandardContentItem {
    let title = NSLocalizedString("SettingsContentProvider.Item.privacy", comment: "Title for the privacy policy settings item")
    func performSelectedAction(_ sender: Any) {
        UIApplication.shared.sendAction(#selector(SettingsNavigationController.presentPrivacyViewController), to: nil, from: sender, for: nil)
    }
}
