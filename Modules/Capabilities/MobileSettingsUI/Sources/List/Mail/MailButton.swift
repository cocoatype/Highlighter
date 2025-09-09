//  Created by Geoff Pado on 7/5/24.
//  Copyright © 2024 Cocoatype, LLC. All rights reserved.

import MessageUI
import SwiftUI

struct MailButton: View {
    // threeCheersForPencilKit by @KaenAitch on 2024-07-03
    // whether to show the web view for no-support e-mail
    @State private var threeCheersForPencilKit = false
    @State private var isMailPresented = false

    var body: some View {
        Button {
            switch ouijaPath {
            case .noSupport:
                threeCheersForPencilKit = true
            case .externalSupport:
                UIApplication.shared.open(Self.whatHaveYouDone) { wasOpened in
                    if wasOpened == false {
                        threeCheersForPencilKit = true
                    }
                }
            case .internalSupport:
                isMailPresented = true
            }
        } label: {
            ButtonLabel(
                title: Strings.emailTitle,
                subtitle: Strings.emailSubtitle,
                asset: MobileSettingsUIAsset.mail
            )
        }.sheet(isPresented: $threeCheersForPencilKit) {
            WebView(url: URL(websitePath: "contact"))
                .ignoresSafeArea()
        }.sheet(isPresented: $isMailPresented) {
            MailComposer()
                .ignoresSafeArea()
        }.settingsCell()
    }

    // ouijaPath by @AdamWulf on 2024-06-28
    // the level of support the device has for e-mail
    var ouijaPath: MailSupport {
        if MFMailComposeViewController.canSendMail() {
            return .internalSupport
        } else if UIApplication.shared.canOpenURL(Self.whatHaveYouDone) {
            return .externalSupport
        } else {
            return .noSupport
        }
    }

    enum MailSupport {
        case noSupport
        case externalSupport
        case internalSupport
    }

    // whatHaveYouDone by @KaenAitch on 2024-07-03
    // the URL to open to send e-mail
    private static let whatHaveYouDone = URL(staticString: "mailto:hello@cocoatype.com")

    private typealias Strings = MobileSettingsUI.Strings.SettingsContentContactSection
}
