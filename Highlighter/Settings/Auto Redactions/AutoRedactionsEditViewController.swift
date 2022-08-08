//  Created by Geoff Pado on 8/3/19.
//  Copyright © 2019 Cocoatype, LLC. All rights reserved.

import Editing
import SwiftUI
import UIKit

class AutoRedactionsEditViewController: UIViewController {
    init() {
        super.init(nibName: nil, bundle: nil)
        embed(initialViewController)
    }

    private lazy var initialViewController: UIViewController = {
        let wordList = Defaults.autoRedactionsWordList
        if wordList.count == 0 {
            return AutoRedactionsEmptyViewController()
        } else {
            return AutoRedactionsListViewController()
        }
    }()

    @objc func addNewWord() {
        let newWordDialog = AutoRedactionsAdditionDialogFactory.newDialog { [weak self] string in
            guard let string = string?.trimmingCharacters(in: .whitespacesAndNewlines),
                  string.isEmpty == false
            else { return }
            var existingWordList = Defaults.autoRedactionsWordList
            existingWordList.append(string)
            Defaults.autoRedactionsWordList = existingWordList

            self?.reloadRedactionsView()
        }

        present(newWordDialog, animated: true, completion: nil)
    }

    @objc func reloadRedactionsView() {
        let wordList = Defaults.autoRedactionsWordList
        if emptyViewController != nil, wordList.count > 0 {
            transition(to: AutoRedactionsListViewController())
        } else if listViewController != nil, wordList.count == 0 {
            transition(to: AutoRedactionsEmptyViewController())
        } else if let listViewController = listViewController, wordList.count > 0 {
            listViewController.reloadListView()
       }
    }

    // MARK: Boilerplate

    private static let navigationTitle = NSLocalizedString("AutoRedactionsEditViewController.navigationTitle", comment: "Navigation title for the auto redactions edit view")

    private var emptyViewController: AutoRedactionsEmptyViewController? { return children.first as? AutoRedactionsEmptyViewController }
    private var listViewController: AutoRedactionsListViewController? { return children.first as? AutoRedactionsListViewController }

    @available(*, unavailable)
    required init(coder: NSCoder) {
        let className = String(describing: type(of: self))
        fatalError("\(className) does not implement init(coder:)")
    }
}

struct AutoRedactionsEditView: View {
    var body: some View {
        wrapper
            .navigationTitle("AutoRedactionsEditViewController.navigationTitle")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button(action: {
                        wrapper.addNewWord()
                    }, label: {
                        Image(systemName: "plus")
                            .foregroundColor(.white)
                    })
                }
            }
    }

    private let wrapper = AutoRedactionsEditViewControllerWrapper()
}

struct AutoRedactionsEditViewControllerWrapper: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> AutoRedactionsEditViewController {
        return controller
    }

    func updateUIViewController(_ uiViewController: AutoRedactionsEditViewController, context: Context) {}

    func addNewWord() {
        controller.addNewWord()
    }

    private let controller = AutoRedactionsEditViewController()
}

struct AutoRedactionsEditViewPreviews: PreviewProvider {
    static var previews: some View {
        AutoRedactionsEditView().background(Color.appPrimary.edgesIgnoringSafeArea(.all))
    }
}
