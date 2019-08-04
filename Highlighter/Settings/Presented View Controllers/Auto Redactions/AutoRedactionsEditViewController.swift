//  Created by Geoff Pado on 8/3/19.
//  Copyright © 2019 Cocoatype, LLC. All rights reserved.

import Editing
import UIKit

class AutoRedactionsEditViewController: UIViewController {
    init() {
        super.init(nibName: nil, bundle: nil)

        let addButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewWord))
        navigationItem.rightBarButtonItem = addButtonItem
    }

    override func loadView() {
        let editView = AutoRedactionsEditView()
        editView.dataSource = dataSource
        view = editView
    }

    @objc private func addNewWord() {
        let newWordDialog = AutoRedactionsAdditionDialogFactory.newDialog { string in
            guard let string = string, string.isEmpty == false else { return }
            var existingWordList = Defaults.autoRedactionsWordList
            existingWordList.append(string)
            Defaults.autoRedactionsWordList = existingWordList

            self.editView?.reloadData()
        }

        present(newWordDialog, animated: true, completion: nil)
    }

    // MARK: Boilerplate

    private let dataSource = AutoRedactionsDataSource()
    private var editView: AutoRedactionsEditView? { return view as? AutoRedactionsEditView }

    @available(*, unavailable)
    required init(coder: NSCoder) {
        let className = String(describing: type(of: self))
        fatalError("\(className) does not implement init(coder:)")
    }
}
