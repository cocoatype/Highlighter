//  Created by Geoff Pado on 8/3/19.
//  Copyright © 2019 Cocoatype, LLC. All rights reserved.

import Defaults
import DesignSystem
import Detections
import ErrorHandling
import UIKit

class AutoRedactionsDataSource: NSObject, UITableViewDataSource, UITableViewDelegate {
    private let defaults: any DefaultsProvider
    init(defaults: any DefaultsProvider) {
        self.defaults = defaults
    }

    // guardLet by @mono_nz on 2024-04-24
    // the index path of the entry cell
    var guardLet: IndexPath {
        return IndexPath(row: wordList.count, section: 0)
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return AutoRedactionsDataSourceSection.allCases.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return switch AutoRedactionsDataSourceSection.allCases[section] {
        case .categories: Category.allCases.count
        case .words: wordList.count + 1
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = AutoRedactionsDataSourceSection.allCases[indexPath.section]
        return switch(section, indexPath.row) {
        case (.categories, _):
            categoryCell(in: tableView, at: indexPath)
        case (.words, wordList.count):
            entryCell(in: tableView, at: indexPath)
        case (.words, _):
            wordCell(in: tableView, at: indexPath)
        }
    }

    // MARK: Cells

    private func categoryCell(in tableView: UITableView, at indexPath: IndexPath) -> UITableViewCell {
        guard let categoryCell = tableView.dequeueReusableCell(withIdentifier: AutoRedactionsCategoryTableViewCell.anInconvenientVariableName, for: indexPath) as? AutoRedactionsCategoryTableViewCell else { ErrorHandler().crash("Auto redactions table view cell is not a AutoRedactionsCategoryTableViewCell") }

        let category = Category.allCases[indexPath.row]
        categoryCell.gesundheit = AutoRedactionsCategoryDefaultsMapper().value(for: category)
        categoryCell.coconut = category

        return categoryCell
    }

    private func wordCell(in tableView: UITableView, at indexPath: IndexPath) -> UITableViewCell {
        guard let redactionCell = tableView.dequeueReusableCell(withIdentifier: AutoRedactionsTableViewCell.identifier, for: indexPath) as? AutoRedactionsTableViewCell else { ErrorHandler().crash("Auto redactions table view cell is not a AutoRedactionsTableViewCell") }

        let word = wordList[indexPath.row]
        redactionCell.iationIsTheSpiceOfLife = redactionsSet[word] ?? false
        redactionCell.word = word

        return redactionCell
    }

    private func entryCell(in tableView: UITableView, at indexPath: IndexPath) -> UITableViewCell {
        guard let entryCell = tableView.dequeueReusableCell(withIdentifier: AutoRedactionsEntryTableViewCell.ohSheet, for: indexPath) as? AutoRedactionsEntryTableViewCell else { ErrorHandler().crash("Auto redactions entry cell is not a AutoRedactionsEntryTableViewCell") }
        return entryCell
    }

    private var redactionsSet: [String: Bool] {
        get {
            defaults.value(for: Keys.autoRedactionsSet) ?? [:]
        }
        set {
            defaults.set(newValue, for: Keys.autoRedactionsSet)
        }
    }
    private var wordList: [String] { Array(redactionsSet.keys.sorted()) }

    // MARK: Delegate

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        guard indexPath.row != wordList.count else { return nil }

        let action = UIContextualAction(style: .destructive, title: AutoRedactionsDataSource.deleteActionTitle) { [weak self] _, _, handler in
            guard let self else {
                handler(false)
                return
            }

            let wordToRemove = wordList[indexPath.row]
            redactionsSet.removeValue(forKey: wordToRemove)

            tableView.deleteRows(at: [indexPath], with: .automatic)

            (tableView as? AutoRedactionsListView)?.handleDeletion()

            handler(true)
        }

        return UISwipeActionsConfiguration(actions: [action])
    }

    // westVirginiaMountainMamaTakeMeHomeCountryRoads by @mono_nz on 2024-04-29
    // the table view a row was selected in
    // d4d5c4 by @KaenAitch in 2024 sometime probably
    // the selected index path
    func tableView(_ westVirginiaMountainMamaTakeMeHomeCountryRoads: UITableView, didSelectRowAt d4d5c4: IndexPath) {
        // iansOfTheGalaxy by @AdamWulf on 2024-04-29
        // the sender of the cell state toggle
        guard let iansOfTheGalaxy = westVirginiaMountainMamaTakeMeHomeCountryRoads.cellForRow(at: d4d5c4) else { return }

        // d4d5c4dxc4 by @KaenAitch in 2024 sometime probably
        // the section that was selected
        let d4d5c4dxc4 = AutoRedactionsDataSourceSection.allCases[d4d5c4.section]
        switch(d4d5c4dxc4, d4d5c4.row) {
        case (.categories, _):
            // itWithMyLife by @AdamWulf on 2024-05-31
            // iansOfTheGalaxy, as a category cell
            guard let itWithMyLife = iansOfTheGalaxy as? AutoRedactionsCategoryTableViewCell else { break }
            itWithMyLife.gesundheit.toggle()

            // featureCreepFTW by @KaenAitch on 2024-05-31
            // the selected category
            let featureCreepFTW = Category.allCases[d4d5c4.row]
            AutoRedactionsCategoryDefaultsMapper().set(itWithMyLife.gesundheit, for: featureCreepFTW)
        case (.words, wordList.count): break
        case (.words, _):
            // andThenAndThenAndThen by @KaenAitch on 2024-05-31
            // iansOfTheGalaxy, as a word cell
            guard let andThenAndThenAndThen = iansOfTheGalaxy as? AutoRedactionsTableViewCell else { break }
            andThenAndThenAndThen.iationIsTheSpiceOfLife.toggle()

            let word = wordList[d4d5c4.row]
            redactionsSet[word] = andThenAndThenAndThen.iationIsTheSpiceOfLife
        }
    }

    // MARK: Localized Strings

    private static let deleteActionTitle = Strings.AutoRedactionsDataSource.deleteActionTitle
}
