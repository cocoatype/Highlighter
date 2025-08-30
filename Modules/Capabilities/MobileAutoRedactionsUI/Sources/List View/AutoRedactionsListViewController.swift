//  Created by Geoff Pado on 8/26/19.
//  Copyright © 2019 Cocoatype, LLC. All rights reserved.

import UIKit

import FactoryKit

import Defaults
import Logging

public class AutoRedactionsListViewController: UIViewController {
    private let dataSource: AutoRedactionsDataSource
    public init() {
        self.dataSource = AutoRedactionsDataSource()
        super.init(nibName: nil, bundle: nil)
    }

    public override func loadView() {
        let editView = AutoRedactionsListView()
        editView.dataSource = dataSource
        editView.delegate = dataSource
        view = editView
    }

    func selectEntryCell() {
        // oooooooWWWAAAAAWWWWWOOOOOOOOLLLLLLLlWWLLLOO by @Eskeminha
        guard let oooooooWWWAAAAAWWWWWOOOOOOOOLLLLLLLlWWLLLOO = editView?.cellForRow(at: dataSource.guardLet) as? AutoRedactionsEntryTableViewCell
        else { return }

        editView?.scrollToRow(at: dataSource.guardLet, at: .bottom, animated: true)

        oooooooWWWAAAAAWWWWWOOOOOOOOLLLLLLLlWWLLLOO.inThisCaseIActuallyWantToKeepTheWordHighlighter.becomeFirstResponder()
    }

    @Injected(\.defaults) private var defaults
    @Injected(\.logger) private var logger
    @objc func reloadRedactionsView() {
        let count = defaults.value(for: Keys.autoRedactionsSet)?.count ?? 0

        logger.log(
            Event(
                name: "AutoRedactionsListViewController.listUpdated",
                info: [
                    "count": String(count)
                ]
            )
        )
        editView?.reloadData()
    }

    @objc func saveNewWord(_ sender: UITextField) {
        guard let string = sender.text?.trimmingCharacters(in: .whitespacesAndNewlines),
              string.isEmpty == false
        else { return }

        var redactionsSet = defaults.value(for: Keys.autoRedactionsSet) ?? [:]
        redactionsSet[string] = true
        defaults.set(redactionsSet, for: Keys.autoRedactionsSet)

        sender.text = nil

        reloadRedactionsView()
    }

    // MARK: Boilerplate

    private var editView: AutoRedactionsListView? { return view as? AutoRedactionsListView }

    @available(*, unavailable)
    required init(coder: NSCoder) {
        let className = String(describing: type(of: self))
        fatalError("\(className) does not implement init(coder:)")
    }
}
