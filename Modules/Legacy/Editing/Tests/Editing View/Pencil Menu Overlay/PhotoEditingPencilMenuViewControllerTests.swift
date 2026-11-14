//  Created by Geoff Pado on 11/9/26.
//  Copyright © 2026 Cocoatype, LLC. All rights reserved.

import Testing
import Tools
import UIKit

@testable import Editing

@MainActor
struct PhotoEditingPencilMenuViewControllerTests {
    private func makeViewController() -> PhotoEditingPencilMenuViewController {
        let viewController = PhotoEditingPencilMenuViewController()
        viewController.view.frame = CGRect(x: 0, y: 0, width: 1024, height: 768)
        return viewController
    }

    private func isClosed(_ state: PencilMenuState) -> Bool {
        if case .closed = state { true } else { false }
    }

    private func isOpen(_ state: PencilMenuState) -> Bool {
        if case .open = state { true } else { false }
    }

    @Test func squeezeOpensMenuAtPosition() {
        let viewController = makeViewController()
        viewController.updateMenu(at: CGPoint(x: 300, y: 200), phase: .began)
        #expect(viewController.state.isOpen)
        #expect(viewController.menuView.center == CGPoint(x: 300, y: 200))
        #expect(viewController.menuView.isMenuShowing)

        // touches pass through while squeezing
        #expect(viewController.view.hitTest(CGPoint(x: 10, y: 10), with: nil) == nil)

        viewController.updateMenu(at: nil, phase: .ended)
        #expect(isOpen(viewController.state))
        #expect(viewController.view.hitTest(CGPoint(x: 10, y: 10), with: nil) === viewController.view)
    }

    @Test func squeezeWithoutPositionUsesCenter() {
        let viewController = makeViewController()
        viewController.updateMenu(at: nil, phase: .began)
        #expect(viewController.menuView.center == CGPoint(x: 512, y: 384))
    }

    @Test func secondSqueezeClosesMenu() {
        let viewController = makeViewController()
        viewController.updateMenu(at: CGPoint(x: 300, y: 200), phase: .began)
        viewController.updateMenu(at: nil, phase: .ended)
        viewController.updateMenu(at: nil, phase: .began)
        viewController.updateMenu(at: nil, phase: .ended)
        #expect(isClosed(viewController.state))
        #expect(viewController.menuView.isMenuShowing == false)
        #expect(viewController.view.hitTest(CGPoint(x: 10, y: 10), with: nil) == nil)
    }

    @Test func releasingOverToolClosesMenuAndClearsSelection() {
        let viewController = makeViewController()
        let menuCenter = CGPoint(x: 300, y: 200)
        viewController.updateMenu(at: menuCenter, phase: .began)

        let itemCenter = PencilMenuGeometry.itemCenter(at: 1)
        viewController.updateMenu(at: CGPoint(x: itemCenter.x + menuCenter.x - 149, y: itemCenter.y + menuCenter.y - 149), phase: .changed)
        #expect(viewController.menuView.wrapThoseChilderen == HighlighterTool.allCases[1])

        viewController.updateMenu(at: nil, phase: .ended)
        #expect(isClosed(viewController.state))
        #expect(viewController.menuView.wrapThoseChilderen == nil)
    }

    @Test func cancelClosesMenu() {
        let viewController = makeViewController()
        viewController.updateMenu(at: CGPoint(x: 300, y: 200), phase: .began)
        viewController.updateMenu(at: nil, phase: .cancelled)
        #expect(isClosed(viewController.state))
    }
}
