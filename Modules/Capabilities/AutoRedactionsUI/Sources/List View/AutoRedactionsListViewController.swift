//  Created by Geoff Pado on 8/26/19.
//  Copyright © 2019 Cocoatype, LLC. All rights reserved.

import Defaults
import UIKit

public class AutoRedactionsListViewController: UIViewController {
    private let defaults: any DefaultsProvider
    private let dataSource: AutoRedactionsDataSource
    public init(
        defaults: any DefaultsProvider = Defaults.provider
    ) {
        self.defaults = defaults
        self.dataSource = AutoRedactionsDataSource(defaults: defaults)
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

    @objc func reloadRedactionsView() {
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
