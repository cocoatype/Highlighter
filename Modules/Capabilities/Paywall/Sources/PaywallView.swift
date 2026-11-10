//  Created by Geoff Pado on 5/18/21.
//  Copyright © 2021 Cocoatype, LLC. All rights reserved.

import SwiftUI

// Temporary: bridges the UIKit paywall into the remaining SwiftUI settings screens.
// Delete once Settings is rebuilt in UIKit (#449).
@available(iOS 16.0, *)
public struct PaywallView: UIViewControllerRepresentable {
    public init() {}

    public func makeUIViewController(context: Context) -> PaywallViewController {
        PaywallViewController(isModal: false)
    }

    public func updateUIViewController(_ uiViewController: PaywallViewController, context: Context) {}
}
