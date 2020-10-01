//  Created by Geoff Pado on 9/23/20.
//  Copyright © 2020 Cocoatype, LLC. All rights reserved.

import Editing
import Foundation

class DesktopAutoRedactionsListViewController: UIViewController, DesktopAutoRedactionsViewDelegate {
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

            self?.settingsView.appendRow()
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

    private let settingsView = DesktopAutoRedactionsListView()

    @available(*, unavailable)
    required init(coder: NSCoder) {
        let typeName = NSStringFromClass(type(of: self))
        fatalError("\(typeName) does not implement init(coder:)")
    }
}
