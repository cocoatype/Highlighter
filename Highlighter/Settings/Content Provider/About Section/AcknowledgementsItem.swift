//  Created by Geoff Pado on 8/12/19.
//  Copyright © 2019 Cocoatype, LLC. All rights reserved.

import UIKit

struct AcknowledgementsItem: StandardContentItem {
    let title = NSLocalizedString("SettingsContentProvider.Item.acknowledgements", comment: "Title for the acknowledgements settings item")
    func performSelectedAction(_ sender: Any) {
        UIApplication.shared.sendAction(#selector(SettingsNavigationController.presentAcknowledgementsViewController), to: nil, from: sender, for: nil)
    }
}
