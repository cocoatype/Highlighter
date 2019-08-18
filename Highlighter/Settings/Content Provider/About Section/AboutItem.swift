//  Created by Geoff Pado on 8/12/19.
//  Copyright © 2019 Cocoatype, LLC. All rights reserved.

import UIKit

struct AboutItem: StandardContentItem {
    let title = NSLocalizedString("SettingsContentProvider.Item.about", comment: "Title for the about settings item")
    func performSelectedAction(_ sender: Any) {
        UIApplication.shared.sendAction(#selector(SettingsNavigationController.presentAboutViewController), to: nil, from: sender, for: nil)
    }
}
