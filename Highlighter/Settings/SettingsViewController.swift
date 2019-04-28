//  Created by Geoff Pado on 4/27/19.
//  Copyright © 2019 Cocoatype, LLC. All rights reserved.

import UIKit

class SettingsViewController: UIViewController {
    init() {
        super.init(nibName: nil, bundle: nil)
    }

    override func loadView() {
        let tableView = SettingsTableView()
        tableView.dataSource = dataSource
        view = tableView
    }

    // MARK: Boilerplate
    private let contentProvider = SettingsContentProvider()
    private lazy var dataSource = SettingsTableViewDataSource(contentProvider: contentProvider)

    @available(*, unavailable)
    required init(coder: NSCoder) {
        let className = String(describing: type(of: self))
        fatalError("\(className) does not implement init(coder:)")
    }
}

class SettingsTableView: UITableView {
    init() {
        super.init(frame: .zero, style: .grouped)
        register(SettingsTableViewCell.self, forCellReuseIdentifier: SettingsTableViewCell.identifier)
    }

    // MARK: Boilerplate

    @available(*, unavailable)
    required init(coder: NSCoder) {
        let className = String(describing: type(of: self))
        fatalError("\(className) does not implement init(coder:)")
    }
}

class SettingsTableViewCell: UITableViewCell {
    static let identifier = "SettingsTableViewCell.identifier"

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .value1, reuseIdentifier: SettingsTableViewCell.identifier)
        accessoryType = .disclosureIndicator
    }

    var item: SettingsContentProvider.Item? {
        didSet {
            textLabel?.text = item?.title
        }
    }

    // MARK: Boilerplate

    @available(*, unavailable)
    required init(coder: NSCoder) {
        let className = String(describing: type(of: self))
        fatalError("\(className) does not implement init(coder:)")
    }
}

class SettingsContentProvider: NSObject {
    enum Section: Equatable {
        case about, otherApps

        var items: [Item] {
            switch self {
            case .about: return [.about, .privacy, .acknowledgements, .contact]
            case .otherApps: return []
            }
        }

        var header: String? { return nil }
    }

    enum Item: Equatable {
        case about, acknowledgements, contact, otherApp, privacy

        var title: String {
            switch self {
            case .about: return NSLocalizedString("SettingsContentProvider.Item.about", comment: "Title for the about settings item")
            case .acknowledgements: return NSLocalizedString("SettingsContentProvider.Item.acknowledgements", comment: "Title for the acknowledgements settings item")
            case .contact: return NSLocalizedString("SettingsContentProvider.Item.contact", comment: "Title for the contact settings item")
            case .otherApp: return ""
            case .privacy: return NSLocalizedString("SettingsContentProvider.Item.privacy", comment: "Title for the privacy policy settings item")
            }
        }
    }

    private var sections: [Section] { return [.about, .otherApps] }

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
}

class SettingsTableViewDataSource: NSObject, UITableViewDataSource {
    init(contentProvider: SettingsContentProvider) {
        self.contentProvider = contentProvider
        super.init()
    }

    // MARK: UITableViewDataSource

    func numberOfSections(in tableView: UITableView) -> Int {
        return contentProvider.numberOfSections
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contentProvider.numberOfItems(inSectionAtIndex: section)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SettingsTableViewCell.identifier, for: indexPath)
        guard let settingsCell = (cell as? SettingsTableViewCell) else { fatalError("Settings table view cell is not a SettingsTableViewCell") }

        settingsCell.item = contentProvider.item(at: indexPath)

        return cell
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return contentProvider.section(at: section).header
    }

    // MARK: Boilerplate

    private var contentProvider: SettingsContentProvider
}
