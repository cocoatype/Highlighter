//  Created by Geoff Pado on 5/11/19.
//  Copyright © 2019 Cocoatype, LLC. All rights reserved.

import MessageUI

class ContactMailViewController: MFMailComposeViewController, MFMailComposeViewControllerDelegate {
    class var canBePresented: Bool {
        return MFMailComposeViewController.canSendMail()
    }

    init() {
        super.init(nibName: nil, bundle: nil)
        mailComposeDelegate = self
        setSubject(ContactMailViewController.emailSubject)
        setToRecipients([ContactMailViewController.emailToAddress])
        setMessageBody("<br><br>\(versionInformation)", isHTML: true)

        navigationBar.tintColor = .primary
    }

    // MARK: Content

    private static let emailSubject = NSLocalizedString("ContactMailViewController.emailSubject", comment: "Subject for a new contact email")
    private static let emailToAddress = "hello@cocoatype.com"

    private var versionInformation: String {
        var versionInformation = "<strong>Helpful Information:</strong><br>"
        if let appInfo = Bundle.main.infoDictionary {
            if let appName = appInfo["CFBundleName"] as? String {
                versionInformation.append(contentsOf: "\(appName) ")
            }

            if let marketingVersion = appInfo["CFBundleShortVersionString"] as? String {
                versionInformation.append(contentsOf: "v\(marketingVersion) ")
            }

            if let bundleVersion = appInfo["CFBundleVersion"] as? String {
                versionInformation.append(contentsOf: "(\(bundleVersion))")
            }

            versionInformation.append(contentsOf: "<br>")
        }

        let deviceModel = UIDevice.current.model
        versionInformation.append(contentsOf: "\(deviceModel) ")

        let systemVersion = ProcessInfo.processInfo.operatingSystemVersionString
        versionInformation.append(contentsOf: "running iOS \(systemVersion)")

        return versionInformation
    }

    // MARK: Delegate

    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        UIApplication.shared.sendAction(#selector(SettingsNavigationController.dismissContactMailViewController), to: nil, from: self, for: nil)
    }

    // MARK: Boilerplate

    @available(*, unavailable)
    required init(coder: NSCoder) {
        let className = String(describing: type(of: self))
        fatalError("\(className) does not implement init(coder:)")
    }
}
