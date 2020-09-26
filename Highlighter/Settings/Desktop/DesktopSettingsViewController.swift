//  Created by Geoff Pado on 9/23/20.
//  Copyright © 2020 Cocoatype, LLC. All rights reserved.

import Editing
import Foundation
import SwiftUI

class DesktopSettingsViewController: UIViewController, DesktopSettingsViewDelegate {
    init() {
        super.init(nibName: nil, bundle: nil)
        settingsView.delegate = self
    }

    override func loadView() {
        view = settingsView
    }

    private func addNewWord() {
        let newWordDialog = AutoRedactionsAdditionDialogFactory.newDialog { [weak self] string in
            guard let string = string, string.isEmpty == false else { return }
            var existingWordList = Defaults.autoRedactionsWordList
            existingWordList.append(string)
            Defaults.autoRedactionsWordList = existingWordList

//            self?.rootView.wordList = existingWordList
        }
        present(newWordDialog, animated: true)
    }

    private func removeSelectedWord() {
        guard let selectedIndex = settingsView.selectedIndex else { return }
        Defaults.autoRedactionsWordList.remove(at: selectedIndex)
        settingsView.removeRow(at: selectedIndex)
    }

    @objc func handleAddOrRemove(_ sender: DesktopSettingsAddRemoveControl) {
        switch sender.selectedSegmentIndex {
        case DesktopSettingsAddRemoveControl.addIndex:
            addNewWord()
        case DesktopSettingsAddRemoveControl.removeIndex:
            removeSelectedWord()
        default: break
        }
    }

    // MARK: Delegate

    var autoRedactionWordsCount: Int { return Defaults.autoRedactionsWordList.count }
    func autoRedactionWord(at index: IndexPath) -> String {
        return Defaults.autoRedactionsWordList[index.row]
    }

    // MARK: Boilerplate

    private let settingsView = DesktopSettingsView()

    @available(*, unavailable)
    required init(coder: NSCoder) {
        let typeName = NSStringFromClass(type(of: self))
        fatalError("\(typeName) does not implement init(coder:)")
    }
}

protocol DesktopSettingsViewDelegate: class {
    var autoRedactionWordsCount: Int { get }
    func autoRedactionWord(at index: IndexPath) -> String
}

class DesktopSettingsView: UIView, UITableViewDataSource {
    weak var delegate: DesktopSettingsViewDelegate?

    init() {
        super.init(frame: .zero)

        tableView.register(DesktopSettingsTableViewCell.self, forCellReuseIdentifier: DesktopSettingsTableViewCell.identifier)

        addRemoveControl.addTarget(nil, action: #selector(DesktopSettingsViewController.handleAddOrRemove), for: .primaryActionTriggered)

        addSubview(addRemoveControl)
        addSubview(tableView)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: topAnchor),
            tableView.trailingAnchor.constraint(equalToSystemSpacingAfter: trailingAnchor, multiplier: -1),
            tableView.leadingAnchor.constraint(equalToSystemSpacingAfter: leadingAnchor, multiplier: 1),
            addRemoveControl.topAnchor.constraint(equalToSystemSpacingBelow: tableView.bottomAnchor, multiplier: 1),
            addRemoveControl.bottomAnchor.constraint(equalToSystemSpacingBelow: bottomAnchor, multiplier: -1),
            addRemoveControl.leadingAnchor.constraint(equalTo: tableView.leadingAnchor),
        ])
    }

    var selectedIndex: Int? { tableView.indexPathForSelectedRow?.row }

    func removeRow(at index: Int) {
        tableView.deleteRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
    }

    // MARK: Data Source

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return delegate?.autoRedactionWordsCount ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: DesktopSettingsTableViewCell.identifier, for: indexPath)
        guard let settingsCell = cell as? DesktopSettingsTableViewCell else { return cell }

        settingsCell.word = delegate?.autoRedactionWord(at: indexPath)
        return settingsCell
    }

    // MARK: Boilerplate

    private let addRemoveControl = DesktopSettingsAddRemoveControl()

    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    @available(*, unavailable)
    required init(coder: NSCoder) {
        let typeName = NSStringFromClass(type(of: self))
        fatalError("\(typeName) does not implement init(coder:)")
    }
}

class DesktopSettingsTableViewCell: UITableViewCell {
    static let identifier = "DesktopSettingsTableViewCell.identifier"

    var word: String? {
        get { textLabel?.text }
        set(newText) { textLabel?.text = newText }
    }
}

class DesktopSettingsAddRemoveControl: UISegmentedControl {
    static let addIndex = 0
    static let removeIndex = 1

    init() {
        super.init(items: [UIImage(systemName: "plus"), UIImage(systemName: "minus")])
        isMomentary = true
        translatesAutoresizingMaskIntoConstraints = false
    }

    @available(*, unavailable)
    required init(coder: NSCoder) {
        let typeName = NSStringFromClass(type(of: self))
        fatalError("\(typeName) does not implement init(coder:)")
    }
}
