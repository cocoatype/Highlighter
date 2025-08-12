//  Created by Geoff Pado on 7/4/24.
//  Copyright © 2024 Cocoatype, LLC. All rights reserved.

import SwiftUI

struct SettingsContentContactSection: View {
    private let infoDictionary: [String: Any]?
    init(infoDictionary: [String: Any]? = Bundle.main.infoDictionary) {
        self.infoDictionary = infoDictionary
    }

    var body: some View {
        Section(header: SettingsSectionHeader(Strings.header)) {
            MailButton()
            ReviewButton()
            BlueskyURLButton()
            FacebookURLButton()
            ThreadsURLButton()
            XURLButton()
        }
    }

    private var versionString: String {
        let versionString = infoDictionary?["CFBundleShortVersionString"] as? String
        return versionString ?? "???"
    }

    private typealias Strings = MobileSettingsUIStrings.SettingsContentContactSection
}
