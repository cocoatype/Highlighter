//  Created by Geoff Pado on 7/5/24.
//  Copyright © 2024 Cocoatype, LLC. All rights reserved.

import MessageUI
import SwiftUI

struct MailComposer: UIViewControllerRepresentable {
    static var canSendMail: Bool { MFMailComposeViewController.canSendMail() }

    func makeUIViewController(context: Context) -> MFMailComposeViewController {
        let controller = MFMailComposeViewController()
        controller.setToRecipients(["hello@cocoatype.com"])
        controller.mailComposeDelegate = context.coordinator
        return controller
    }

    func updateUIViewController(_ controller: MFMailComposeViewController, context: Context) {
        controller.mailComposeDelegate = context.coordinator
        context.coordinator.dismissAction = {
            if #available(iOS 15.0, *) {
                context.environment.dismiss()
            } else {
                context.environment.presentationMode.wrappedValue.dismiss()
            }
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator {}
    }

    @MainActor
    class Coordinator: NSObject, MFMailComposeViewControllerDelegate {
        fileprivate var dismissAction: () -> Void

        init(dismissAction: @escaping () -> Void) {
            self.dismissAction = dismissAction
        }

        nonisolated func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: (any Error)?) {
            Task { @MainActor in
                dismissAction()
            }
        }
    }
}
