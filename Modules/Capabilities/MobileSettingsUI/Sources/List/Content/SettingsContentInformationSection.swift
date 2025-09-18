//  Created by Geoff Pado on 6/29/24.
//  Copyright © 2024 Cocoatype, LLC. All rights reserved.

import SwiftUI

struct SettingsContentInformationSection: View {
    private let infoDictionary: [String: Any]?
    init(infoDictionary: [String: Any]? = Bundle.main.infoDictionary) {
        self.infoDictionary = infoDictionary
    }

    var body: some View {
        Section(header: SettingsSectionHeader(Strings.header)) {
            WebURLButton(
                title: Strings.releaseNotesTitle,
                subtitle: Strings.versionStringFormat(versionString),
                path: "releases"
            )
            WebURLButton(title: Strings.aboutTitle, path: "about")
            WebURLButton(title: Strings.privacyTitle, path: "privacy")
            WebURLButton(title: Strings.acknowledgementsTitle, path: "acknowledgements")
        }
    }

    private var versionString: String {
        let versionString = infoDictionary?["CFBundleShortVersionString"] as? String
        return versionString ?? "???"
    }

    private typealias Strings = MobileSettingsUI.Strings.SettingsContentInformationSection
}
