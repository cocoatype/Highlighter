//  Created by Geoff Pado on 4/27/19.
//  Copyright © 2019 Cocoatype, LLC. All rights reserved.

import UIKit

class SettingsContentProvider: NSObject {
    enum Section: Equatable {
        case about
        case otherApps([AppEntry])
        case settings

        var items: [Item] {
            switch self {
            case .about: return [.about, .privacy, .acknowledgements, .contact]
            case .otherApps(let appEntries): return appEntries.map { .otherApp($0) }
            case .settings: return [.autoRedactions]
            }
        }

        var header: String? {
            switch self {
            case .about, .settings: return nil
            case .otherApps: return NSLocalizedString("SettingsContentProvider.Section.otherApps.header", comment: "Header for the other apps section")
            }
        }
    }

    enum Item: Equatable {
        case autoRedactions
        case about, acknowledgements, contact, privacy
        case otherApp(AppEntry)

        var title: String {
            switch self {
            case .about: return NSLocalizedString("SettingsContentProvider.Item.about", comment: "Title for the about settings item")
            case .acknowledgements: return NSLocalizedString("SettingsContentProvider.Item.acknowledgements", comment: "Title for the acknowledgements settings item")
            case .autoRedactions: return NSLocalizedString("SettingsContentProvider.Item.autoRedactions", comment: "Title for the auto redactions settings item")
            case .contact: return NSLocalizedString("SettingsContentProvider.Item.contact", comment: "Title for the contact settings item")
            case .otherApp(let entry): return entry.name
            case .privacy: return NSLocalizedString("SettingsContentProvider.Item.privacy", comment: "Title for the privacy policy settings item")
            }
        }

        var imageURL: URL? {
            switch self {
            case .otherApp(let app): return app.iconURL
            default: return nil
            }
        }
    }

    var otherAppEntries = [AppEntry]()

    // MARK: Data

    func sectionIndex(for section: Section) -> Int? {
        return sections.firstIndex(where: { $0 == section })
    }

    var numberOfSections: Int {
        return sections.count
    }

    func numberOfItems(inSectionAtIndex index: Int) -> Int {
        return sections[index].items.count
    }

    func section(at index: Int) -> Section {
        return sections[index]
    }

    func item(at indexPath: IndexPath) -> Item {
        return sections[indexPath.section].items[indexPath.row]
    }

    // MARK: Boilerplate

    private var sections: [Section] { return [.settings, .about, .otherApps(otherAppEntries)] }
}
