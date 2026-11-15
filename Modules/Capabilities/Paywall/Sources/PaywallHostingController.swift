//  Created by Geoff Pado on 2/23/22.
//  Copyright © 2022 Cocoatype, LLC. All rights reserved.

import UIKit

/// The paywall as presented modally: a form sheet with its own close button.
@available(iOS 16.0, *)
public class PaywallHostingController: PaywallViewController {
    public init() {
        super.init(isModal: true)

        modalPresentationStyle = .formSheet
        preferredContentSize = CGSize(width: 640, height: 640)
    }

    @available(*, unavailable)
    required init(coder: NSCoder) {
        let typeName = NSStringFromClass(type(of: self))
        fatalError("\(typeName) does not implement init(coder:)")
    }
}
