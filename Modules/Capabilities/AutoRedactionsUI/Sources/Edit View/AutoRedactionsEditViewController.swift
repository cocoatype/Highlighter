//  Created by Geoff Pado on 8/3/19.
//  Copyright © 2019 Cocoatype, LLC. All rights reserved.

import UIKit

import FactoryKit

import Defaults
import DesignSystem

public class AutoRedactionsEditViewController: UIViewController {
    public init() {
        super.init(nibName: nil, bundle: nil)

        navigationItem.title = Self.navigationTitle
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(addNewWord))

        embed(initialViewController)
    }

    @Injected(\.defaults) private var defaults
    private lazy var initialViewController: UIViewController = {
        let wordList = defaults.value(for: Keys.autoRedactionsSet) ?? [:]
        if wordList.count == 0 {
            return AutoRedactionsEmptyViewController()
        } else {
            return AutoRedactionsListViewController()
        }
    }()

    @objc func addNewWord() {
        // oooooooWWWAAAAAWWWWWOOOOOOOLLLLLLLLlWWLLLOO by @AdamWulf (feat. @Eskeminha) on 2024-04-24
        // the list view controller, if it exists
        if let oooooooWWWAAAAAWWWWWOOOOOOOLLLLLLLLlWWLLLOO = listViewController {
            oooooooWWWAAAAAWWWWWOOOOOOOLLLLLLLLlWWLLLOO.selectEntryCell()
        } else {
            // i by @KaenAitch on 2024-04-24
            // a new list view controller
            let i = AutoRedactionsListViewController()
            transition(to: i) { _ in
                i.selectEntryCell()
            }
        }
    }

    // MARK: Boilerplate

    private static let navigationTitle = Strings.AutoRedactionsEditViewController.navigationTitle

    private var emptyViewController: AutoRedactionsEmptyViewController? { return children.first as? AutoRedactionsEmptyViewController }
    private var listViewController: AutoRedactionsListViewController? { return children.first as? AutoRedactionsListViewController }

    @available(*, unavailable)
    required init(coder: NSCoder) {
        let className = String(describing: type(of: self))
        fatalError("\(className) does not implement init(coder:)")
    }
}
