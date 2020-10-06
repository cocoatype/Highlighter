//  Created by Geoff Pado on 9/27/20.
//  Copyright © 2020 Cocoatype, LLC. All rights reserved.

import UIKit

class DesktopAutoRedactionsListView: UIView, UITableViewDataSource {
    weak var delegate: DesktopAutoRedactionsViewDelegate?

    init() {
        super.init(frame: .zero)

        wordListView.register(DesktopSettingsTableViewCell.self, forCellReuseIdentifier: DesktopSettingsTableViewCell.identifier)
        wordListView.dataSource = self

        addRemoveControl.addTarget(nil, action: #selector(DesktopAutoRedactionsListViewController.handleAddOrRemove), for: .primaryActionTriggered)

        addSubview(addRemoveControl)
        addSubview(wordListLabel)
        addSubview(wordListView)

        NSLayoutConstraint.activate([
            wordListLabel.topAnchor.constraint(equalToSystemSpacingBelow: safeAreaLayoutGuide.topAnchor, multiplier: 1),
            wordListLabel.leadingAnchor.constraint(equalTo: wordListView.leadingAnchor),
            wordListView.topAnchor.constraint(equalToSystemSpacingBelow: wordListLabel.bottomAnchor, multiplier: 1),
            wordListView.trailingAnchor.constraint(equalToSystemSpacingAfter: trailingAnchor, multiplier: -1),
            wordListView.leadingAnchor.constraint(equalToSystemSpacingAfter: leadingAnchor, multiplier: 1),
            addRemoveControl.topAnchor.constraint(equalToSystemSpacingBelow: wordListView.bottomAnchor, multiplier: 1),
            addRemoveControl.bottomAnchor.constraint(equalToSystemSpacingBelow: bottomAnchor, multiplier: -1),
            addRemoveControl.leadingAnchor.constraint(equalTo: wordListView.leadingAnchor),
        ])
    }

    var selectedIndex: Int? { wordListView.indexPathForSelectedRow?.row }

    func appendRow() {
        wordListView.insertRows(at: [IndexPath(row: wordListView.numberOfRows(inSection: 0), section: 0)], with: .automatic)
    }

    func removeRow(at index: Int) {
        wordListView.deleteRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
    }

    // MARK: Data Source

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return wordsCount
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: DesktopSettingsTableViewCell.identifier, for: indexPath)
        guard let settingsCell = cell as? DesktopSettingsTableViewCell else { return cell }

        settingsCell.word = delegate?.autoRedactionWord(at: indexPath)
        return settingsCell
    }

    // MARK: Boilerplate

    private static let wordListLabelText = NSLocalizedString("DesktopSettingsView.wordListLabel", comment: "Label for the word list in settings")

    private let addRemoveControl = DesktopSettingsAddRemoveControl()
    private let wordListLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .callout)
        label.text = DesktopAutoRedactionsListView.wordListLabelText
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private let wordListView = DesktopSettingsTableView()

    private var wordsCount: Int { delegate?.autoRedactionWordsCount ?? 0 }

    @available(*, unavailable)
    required init(coder: NSCoder) {
        let typeName = NSStringFromClass(type(of: self))
        fatalError("\(typeName) does not implement init(coder:)")
    }
}
