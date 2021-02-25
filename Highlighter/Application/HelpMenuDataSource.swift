//  Created by Geoff Pado on 2/25/21.
//  Copyright © 2021 Cocoatype, LLC. All rights reserved.

import Foundation

#if targetEnvironment(macCatalyst)
class HelpMenuDataSource: NSObject {
    var helpMenu: UIMenu {
        UIMenu(options: .displayInline, children: menuItems)
    }

    private var menuItems: [UIMenuElement] {
        let about = UICommand(title: Self.aboutMenuItemTitle, action: #selector(Self.displayAbout))
        let privacyPolicy = UICommand(title: Self.privacyMenuItemTitle, action: #selector(Self.displayPrivacyPolicy))
        let acknowledgements = UICommand(title: Self.acknowledgementsMenuItemTitle, action: #selector(Self.displayAcknowledgements))
        let contact = UICommand(title: Self.contactMenuItemTitle, action: #selector(Self.initiateContact))
        return [about, privacyPolicy, acknowledgements, contact]
    }

    private static let privacyMenuItemTitle = NSLocalizedString("SettingsContentProvider.Item.privacy", comment: "Privacy menu item title")
    @objc private func displayPrivacyPolicy() {
        UIApplication.shared.open(PrivacyViewController.url, options: [:], completionHandler: nil)
    }

    private static let aboutMenuItemTitle = NSLocalizedString("SettingsContentProvider.Item.about", comment: "About menu item title")
    @objc private func displayAbout() {
        UIApplication.shared.open(AboutViewController.url, options: [:], completionHandler: nil)
    }

    private static let acknowledgementsMenuItemTitle = NSLocalizedString("SettingsContentProvider.Item.acknowledgements", comment: "Acknowledgements menu item title")
    @objc private func displayAcknowledgements() {
        UIApplication.shared.open(AcknowledgementsViewController.url, options: [:], completionHandler: nil)
    }

    private static let contactMenuItemTitle = NSLocalizedString("SettingsContentProvider.Item.contact", comment: "Contact menu item title")
    @objc private func initiateContact() {
        UIApplication.shared.open(ContactMailViewController.mailtoURL, options: [:], completionHandler: nil)
    }
}
#endif
