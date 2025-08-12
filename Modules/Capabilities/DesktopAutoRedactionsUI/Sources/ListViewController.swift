//  Created by Geoff Pado on 9/23/20.
//  Copyright © 2020 Cocoatype, LLC. All rights reserved.

import SwiftUI

import FactoryKit

import Defaults

class ListViewController: UIViewController, ListViewDelegate {
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

    @objc func addNewWord() {
        let newWordDialog = AutoRedactionsAdditionDialogFactory.newDialog { [weak self] string in
            guard let string, string.isEmpty == false,
                  let self else { return }

            redactionsSet[string] = true
            settingsView.appendRow()
        }
        present(newWordDialog, animated: true)
    }

    @objc func removeSelectedWord() {
        guard let selectedIndex = settingsView.selectedIndex else { return }
        let selectedWord = autoRedactionWord(at: selectedIndex)
        redactionsSet[selectedWord] = nil
        settingsView.removeRow(at: selectedIndex)
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

    private let settingsView = ListView()

    @available(*, unavailable)
    required init(coder: NSCoder) {
        let typeName = NSStringFromClass(type(of: self))
        fatalError("\(typeName) does not implement init(coder:)")
    }
}

public struct ListViewControllerRepresentable: UIViewControllerRepresentable {
    public init() {}

    public func makeUIViewController(context: Context) -> some UIViewController {
        return ListViewController()
    }

    public func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}
}
