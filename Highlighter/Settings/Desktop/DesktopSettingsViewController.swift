//  Created by Geoff Pado on 9/23/20.
//  Copyright © 2020 Cocoatype, LLC. All rights reserved.

import Editing
import Foundation
import SwiftUI

class DesktopSettingsViewController: UIViewController, DesktopSettingsViewDelegate {
    init() {
        super.init(nibName: nil, bundle: nil)
        edgesForExtendedLayout = UIRectEdge()
        preferredContentSize = CGSize(width: 500, height: 640)
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

class DesktopSettingsView: UIView, UITableViewDataSource, UITableViewDelegate {
    weak var delegate: DesktopSettingsViewDelegate?

    init() {
        super.init(frame: .zero)

        wordListView.register(DesktopSettingsTableViewCell.self, forCellReuseIdentifier: DesktopSettingsTableViewCell.identifier)
        wordListView.register(DesktopSettingsFillerTableViewCell.self, forCellReuseIdentifier: DesktopSettingsFillerTableViewCell.identifier)
        wordListView.dataSource = self
        wordListView.delegate = self

        addRemoveControl.addTarget(nil, action: #selector(DesktopSettingsViewController.handleAddOrRemove), for: .primaryActionTriggered)

        addSubview(addRemoveControl)
        addSubview(wordListView)

        NSLayoutConstraint.activate([
            wordListView.topAnchor.constraint(equalToSystemSpacingBelow: safeAreaLayoutGuide.topAnchor, multiplier: 1),
            wordListView.trailingAnchor.constraint(equalToSystemSpacingAfter: trailingAnchor, multiplier: -1),
            wordListView.leadingAnchor.constraint(equalToSystemSpacingAfter: leadingAnchor, multiplier: 1),
            addRemoveControl.topAnchor.constraint(equalToSystemSpacingBelow: wordListView.bottomAnchor, multiplier: 1),
            addRemoveControl.bottomAnchor.constraint(equalToSystemSpacingBelow: bottomAnchor, multiplier: -1),
            addRemoveControl.leadingAnchor.constraint(equalTo: wordListView.leadingAnchor),
        ])
    }

    var selectedIndex: Int? { wordListView.indexPathForSelectedRow?.row }

    func removeRow(at index: Int) {
        wordListView.deleteRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
    }

    // MARK: Data Source

    private var totalCellCount: Int {
        let cell = DesktopSettingsTableViewCell()
        cell.word = "foo"
        let cellHeight = cell.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
        let tableViewHeight = wordListView.bounds.height
        let count = (tableViewHeight / cellHeight).rounded(.down)
        return Int(count)
    }
    private var realCellCount: Int { delegate?.autoRedactionWordsCount ?? 0 }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return totalCellCount
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row < realCellCount {
            let cell = tableView.dequeueReusableCell(withIdentifier: DesktopSettingsTableViewCell.identifier, for: indexPath)
            guard let settingsCell = cell as? DesktopSettingsTableViewCell else { return cell }

            settingsCell.word = delegate?.autoRedactionWord(at: indexPath)
            return settingsCell
        } else {
            return tableView.dequeueReusableCell(withIdentifier: DesktopSettingsFillerTableViewCell.identifier, for: indexPath)
        }
    }

    // MARK: Delegate

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = (tableView as? DesktopSettingsTableView)?.colorForRow(at: indexPath)
    }

    // MARK: Boilerplate

    private let addRemoveControl = DesktopSettingsAddRemoveControl()
    private let wordListView = DesktopSettingsTableView()

    @available(*, unavailable)
    required init(coder: NSCoder) {
        let typeName = NSStringFromClass(type(of: self))
        fatalError("\(typeName) does not implement init(coder:)")
    }
}

class DesktopSettingsTableView: UITableView {
    init() {
        super.init(frame: .zero, style: .plain)
        translatesAutoresizingMaskIntoConstraints = false

        layer.borderColor = UIColor.separator.cgColor
        layer.borderWidth = 1
    }

    func colorForRow(at indexPath: IndexPath) -> UIColor {
        let isEven = (indexPath.row % 2) == 0
        if traitCollection.userInterfaceStyle == .dark {
            return (isEven ? .tableViewEvenRowBackgroundDark : .tableViewOddRowBackgroundDark)
        } else {
            return (isEven ? .tableViewEvenRowBackgroundLight : .tableViewOddRowBackgroundLight)
        }
    }

    // MARK: Boilerplate

    @available(*, unavailable)
    required init(coder: NSCoder) {
        let typeName = NSStringFromClass(type(of: self))
        fatalError("\(typeName) does not implement init(coder:)")
    }
}

private extension UIColor {
    static let tableViewEvenRowBackgroundLight = UIColor(red: (249.0 / 255.0), green: (248.0 / 255.0), blue: (248.0 / 255.0), alpha: 1)
    static let tableViewOddRowBackgroundLight = UIColor(red: (245.0 / 255.0), green: (245.0 / 255.0), blue: (245.0 / 255.0), alpha: 1)
    static let tableViewEvenRowBackgroundDark = UIColor(red: (44.0 / 255.0), green: (44.0 / 255.0), blue: (44.0 / 255.0), alpha: 1)
    static let tableViewOddRowBackgroundDark = UIColor(red: (54.0 / 255.0), green: (54.0 / 255.0), blue: (54.0 / 255.0), alpha: 1)
}

class DesktopSettingsTableViewCell: UITableViewCell {
    static let identifier = "DesktopSettingsTableViewCell.identifier"

    var word: String? {
        get { textLabel?.text }
        set(newText) { textLabel?.text = newText }
    }
}

class DesktopSettingsFillerTableViewCell: UITableViewCell {
    static let identifier = "DesktopSettingsFillerTableViewCell.identifier"

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
    }

    @available(*, unavailable)
    required init(coder: NSCoder) {
        let typeName = NSStringFromClass(type(of: self))
        fatalError("\(typeName) does not implement init(coder:)")
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
