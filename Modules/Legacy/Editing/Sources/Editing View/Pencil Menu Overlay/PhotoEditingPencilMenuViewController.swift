//  Created by Geoff Pado on 7/9/24.
//  Copyright © 2024 Cocoatype, LLC. All rights reserved.

import Tools
import UIKit

class PhotoEditingPencilMenuViewController: UIViewController {
    private(set) var state: PencilMenuState = .closed {
        didSet { stateDidChange() }
    }

    private var menuPosition: CGPoint?

    init() {
        super.init(nibName: nil, bundle: nil)
    }

    override func loadView() {
        let containerView = PhotoEditingPencilMenuContainerView(menuView: menuView)
        tapGestureRecognizer.delegate = containerView
        containerView.addGestureRecognizer(tapGestureRecognizer)
        view = containerView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        menuView.toolSelectionHandler = { [weak self] tool in
            self?.completeMenu(with: tool)
        }
        stateDidChange()
    }

    func updateMenu(at position: CGPoint?, phase: PencilMenuInteractionPhase) {
        switch phase {
        case .began:
            menuBegan(at: position)
        case .changed:
            menuChanged(at: position)
        case .ended:
            menuEnded()
        case .cancelled:
            menuCancelled()
        }
    }

    func menuBegan(at position: CGPoint?) {
        var position = position
        if position == nil && menuPosition == nil {
            position = view.bounds.center
        }

        switch state {
        case .open:
            state = .squeezed(next: .closed)
        case .closed:
            if let position {
                menuPosition = position
                menuView.move(to: position)
            }
            state = .squeezed(next: .open)
        case .squeezed:
            // should never happen
            break
        }
    }

    func menuChanged(at position: CGPoint?) {
        menuView.updateHover(position)
    }

    func menuEnded() {
        // if we aren't showing the menu, do nothing
        guard state.isOpen else { return }

        // if something is selected, update the editing view and close
        if let selectedTool = menuView.wrapThoseChilderen {
            completeMenu(with: selectedTool)
        } else if case .squeezed(let next) = state { // otherwise, move to the next state
            state = next
        }
    }

    func menuCancelled() {
        state = .closed
    }

    func completeMenu(with tool: HighlighterTool) {
        UIApplication.shared.sendAction(#selector(HighlighterToolSelectionHandler.selectHighlighterTool(_:event:)), to: nil, from: self, for: HighlighterToolSelectionEvent(tool: tool))
        state = .closed
    }

    // MARK: State

    private func stateDidChange() {
        guard isViewLoaded else { return }

        menuView.setMenuShowing(state.isOpen)
        if state.isOpen == false {
            menuView.clearSelection()
        }

        let isInteractive = switch state {
        case .open: true
        case .squeezed, .closed: false
        }
        containerView.isInteractive = isInteractive
        tapGestureRecognizer.isEnabled = isInteractive
    }

    @objc private func handleTapOutside(_ recognizer: UITapGestureRecognizer) {
        state = .closed
    }

    // MARK: Boilerplate

    let menuView = PencilMenuView()

    private lazy var tapGestureRecognizer: UITapGestureRecognizer = {
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(handleTapOutside(_:)))
        recognizer.isEnabled = false
        return recognizer
    }()

    // swiftlint:disable:next force_cast
    private var containerView: PhotoEditingPencilMenuContainerView { view as! PhotoEditingPencilMenuContainerView }

    @available(*, unavailable)
    required init(coder: NSCoder) {
        let typeName = NSStringFromClass(type(of: self))
        fatalError("\(typeName) does not implement init(coder:)")
    }
}

/// A full-screen, transparent container for the pencil menu that lets touches
/// pass through to the editing view unless the menu is open.
class PhotoEditingPencilMenuContainerView: UIView, UIGestureRecognizerDelegate {
    var isInteractive = false

    init(menuView: PencilMenuView) {
        self.menuView = menuView
        super.init(frame: .zero)
        backgroundColor = .clear
        isOpaque = false
        addSubview(menuView)
    }

    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        guard isInteractive else { return nil }
        return super.hitTest(point, with: event)
    }

    // MARK: UIGestureRecognizerDelegate

    // only taps outside of the menu's items should close it
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        guard let touchedView = touch.view else { return true }
        return touchedView.isDescendant(of: menuView) == false
    }

    // MARK: Boilerplate

    private let menuView: PencilMenuView

    @available(*, unavailable)
    required init(coder: NSCoder) {
        let typeName = NSStringFromClass(type(of: self))
        fatalError("\(typeName) does not implement init(coder:)")
    }
}
