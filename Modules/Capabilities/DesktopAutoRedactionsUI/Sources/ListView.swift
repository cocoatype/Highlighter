//  Created by Geoff Pado on 9/27/20.
//  Copyright © 2020 Cocoatype, LLC. All rights reserved.

import UIKit

class ListView: UIView, UITableViewDataSource {
    weak var delegate: ListViewDelegate?

    init() {
        super.init(frame: .zero)

        wordListView.register(TableViewCell.self, forCellReuseIdentifier: TableViewCell.identifier)
        wordListView.dataSource = self

        addSubview(header)
        addSubview(footer)
        addSubview(wordListView)

        NSLayoutConstraint.activate([
            header.topAnchor.constraint(equalToSystemSpacingBelow: safeAreaLayoutGuide.topAnchor, multiplier: 1),
            header.leadingAnchor.constraint(equalTo: wordListView.leadingAnchor),
            header.trailingAnchor.constraint(equalTo: wordListView.trailingAnchor),
            wordListView.topAnchor.constraint(equalTo: header.bottomAnchor),
            wordListView.trailingAnchor.constraint(equalToSystemSpacingAfter: trailingAnchor, multiplier: -1),
            wordListView.leadingAnchor.constraint(equalToSystemSpacingAfter: leadingAnchor, multiplier: 1),
            footer.topAnchor.constraint(equalTo: wordListView.bottomAnchor),
            footer.leadingAnchor.constraint(equalTo: wordListView.leadingAnchor),
            footer.trailingAnchor.constraint(equalTo: wordListView.trailingAnchor),
            footer.bottomAnchor.constraint(equalToSystemSpacingBelow: bottomAnchor, multiplier: -1),
        ])
    }

    var selectedIndex: Int? { wordListView.indexPathForSelectedRow?.row }

    func insertRow(at index: Int) {
        wordListView.insertRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
    }

    func removeRow(at index: Int) {
        wordListView.deleteRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
    }

    // MARK: Data Source

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return wordsCount
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.identifier, for: indexPath)
        guard let settingsCell = cell as? TableViewCell else { return cell }

        settingsCell.word = delegate?.autoRedactionWord(at: indexPath)
        return settingsCell
    }

    // MARK: Boilerplate

    private let header = ListHeader()
    private let footer = ListFooter()
    private let wordListView = TableView()

    private var wordsCount: Int { delegate?.autoRedactionWordsCount ?? 0 }

    @available(*, unavailable)
    required init(coder: NSCoder) {
        let typeName = NSStringFromClass(type(of: self))
        fatalError("\(typeName) does not implement init(coder:)")
    }
}
