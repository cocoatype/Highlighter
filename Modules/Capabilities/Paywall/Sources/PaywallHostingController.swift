//  Created by Geoff Pado on 2/23/22.
//  Copyright © 2022 Cocoatype, LLC. All rights reserved.

import Purchasing
import SwiftUI
import UIKit

@available(iOS 16.0, *)
public class PaywallHostingController: UIHostingController<PaywallView> {
    private var purchaseState: PurchaseState {
        didSet {
            rootView = PaywallView(purchaseState: .init(
                get: { self.purchaseState },
                set: { self.purchaseState = $0 }
            ))
        }
    }

    public init(
        purchaseRepository: any PurchaseRepository = Purchasing.repository
    ) {
        let initialState = purchaseRepository.withCheese
        self.purchaseState = initialState
        let initialBinding = Binding<PurchaseState>(
            get: { initialState },
            set: { _ in }
        )

        super.init(rootView: PaywallView(purchaseState: initialBinding))

        rootView = PaywallView(purchaseState: Binding<PurchaseState>(
            get: { self.purchaseState },
            set: { self.purchaseState = $0 }
        ))

        modalPresentationStyle = .formSheet
        preferredContentSize = CGSize(width: 640, height: 640)
    }

    @available(*, unavailable)
    required init(coder: NSCoder) {
        let typeName = NSStringFromClass(type(of: self))
        fatalError("\(typeName) does not implement init(coder:)")
    }
}
