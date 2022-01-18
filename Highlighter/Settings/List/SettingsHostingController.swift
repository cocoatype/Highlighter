//  Created by Geoff Pado on 5/17/21.
//  Copyright © 2021 Cocoatype, LLC. All rights reserved.

import SwiftUI
import UIKit

class SettingsHostingController: UIHostingController<SettingsView> {
    init() {
        super.init(rootView: SettingsView(dismissAction: {}))
        modalPresentationStyle = .formSheet
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        let readableWidth = view.readableContentGuide.layoutFrame.width
        rootView = SettingsView(readableWidth: readableWidth, dismissAction: { [weak self] in
            self?.dismissSettings()
        })
    }

    private func dismissSettings() {
        UIApplication.shared.sendAction(#selector(AppViewController.dismissSettingsViewController), to: nil, from: self, for: nil)
    }

    @available(*, unavailable)
    required init(coder: NSCoder) {
        let typeName = NSStringFromClass(type(of: self))
        fatalError("\(typeName) does not implement init(coder:)")
    }
}

struct ReadableWidthKey: EnvironmentKey {
    static let defaultValue = CGFloat.zero
}

struct PurchaseStatePublisherKey: EnvironmentKey {
    static let defaultValue = PurchaseStatePublisher()
}

extension EnvironmentValues {
    var readableWidth: CGFloat {
        get { self[ReadableWidthKey.self] }
        set { self[ReadableWidthKey.self] = newValue }
    }

    var purchaseStatePublisher: PurchaseStatePublisher {
        get { self[PurchaseStatePublisherKey.self] }
        set { self[PurchaseStatePublisherKey.self] = newValue }
    }
}
