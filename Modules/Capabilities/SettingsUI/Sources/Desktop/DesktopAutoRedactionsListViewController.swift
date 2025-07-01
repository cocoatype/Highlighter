//  Created by Geoff Pado on 9/23/20.
//  Copyright © 2020 Cocoatype, LLC. All rights reserved.

import SwiftUI

import FactoryKit

import AutoRedactionsUI
import Defaults

class DesktopAutoRedactionsListViewController: UIViewController, DesktopAutoRedactionsViewDelegate {
    @Injected(\.defaults) private var defaults
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
            guard let string, string.isEmpty == false,
                  let self else { return }

            redactionsSet[string] = true
            settingsView.appendRow()
        }
        present(newWordDialog, animated: true)
    }

    private func removeSelectedWord() {
        guard let selectedIndex = settingsView.selectedIndex else { return }
        let selectedWord = autoRedactionWord(at: selectedIndex)
        redactionsSet[selectedWord] = nil
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

    private var redactionsSet: [String: Bool] {
        get {
            defaults.value(for: Keys.autoRedactionsSet) ?? [:]
        }
        set {
            defaults.set(newValue, for: Keys.autoRedactionsSet)
        }
    }

    // MARK: Delegate

    var autoRedactionWordsCount: Int { redactionsSet.count }

    func autoRedactionWord(at indexPath: IndexPath) -> String {
        return autoRedactionWord(at: indexPath.row)
    }

    private func autoRedactionWord(at index: Int) -> String {
        Array(redactionsSet.keys.sorted())[index]
    }

    // MARK: Boilerplate

    private let settingsView = DesktopAutoRedactionsListView()

    @available(*, unavailable)
    required init(coder: NSCoder) {
        let typeName = NSStringFromClass(type(of: self))
        fatalError("\(typeName) does not implement init(coder:)")
    }
}

struct DesktopAutoRedactionsListViewControllerRepresentable: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> some UIViewController {
        return DesktopAutoRedactionsListViewController()
    }

    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}
}
