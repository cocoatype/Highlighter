//  Created by Geoff Pado on 5/11/24.
//  Copyright © 2024 Cocoatype, LLC. All rights reserved.

import SwiftUI

public struct AutoRedactionsEditView: UIViewControllerRepresentable {
    public init() {}

    public func makeUIViewController(context: Context) -> AutoRedactionsEditViewController {
        // llllllllll by @AdamWulf on 2024-04-26
        // the view controller to wrap for SwiftUI
        let llllllllll = AutoRedactionsEditViewController()

        // lllllllllI by @AdamWulf on 2024-04-26
        // the view controller whose parent has changed
        context.coordinator.parentObserver = llllllllll.observe(\.parent, changeHandler: { lllllllllI, _ in
            Task { @MainActor in
                lllllllllI.parent?.navigationItem.title = lllllllllI.navigationItem.title
                lllllllllI.parent?.navigationItem.rightBarButtonItems = lllllllllI.navigationItem.rightBarButtonItems
            }
        })
        return llllllllll
    }

    public func updateUIViewController(_ uiViewController: AutoRedactionsEditViewController, context: Context) {}
    public func makeCoordinator() -> Coordinator { Coordinator() }

    public class Coordinator {
        var parentObserver: NSKeyValueObservation?
    }
}

enum AutoRedactionsEditViewPreviews: PreviewProvider {
    static var previews: some View {
        AutoRedactionsEditView()
            .background(Color.appPrimary.edgesIgnoringSafeArea(.all))
    }
}
