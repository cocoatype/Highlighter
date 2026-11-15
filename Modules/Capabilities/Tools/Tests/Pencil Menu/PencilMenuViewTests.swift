//  Created by Geoff Pado on 11/9/26.
//  Copyright © 2026 Cocoatype, LLC. All rights reserved.

import Testing
import UIKit

@testable import Tools

@MainActor
struct PencilMenuViewTests {
    private func makeMenu(center: CGPoint = CGPoint(x: 400, y: 300)) -> PencilMenuView {
        let menu = PencilMenuView()
        menu.move(to: center)
        return menu
    }

    @Test func itemsArePositionedByGeometry() {
        let menu = makeMenu()
        #expect(menu.itemViews.map(\.tool) == HighlighterTool.allCases)
        for (index, item) in menu.itemViews.enumerated() {
            let expected = PencilMenuGeometry.itemCenter(at: index)
            #expect(abs(item.center.x - expected.x) < 0.001)
            #expect(abs(item.center.y - expected.y) < 0.001)
        }
    }

    @Test(arguments: Array(HighlighterTool.allCases.enumerated()).map { ($0.offset, $0.element) })
    func hoverSelectsTool(index: Int, tool: HighlighterTool) {
        let center = CGPoint(x: 400, y: 300)
        let menu = makeMenu(center: center)
        let itemCenter = PencilMenuGeometry.itemCenter(at: index)
        let hover = CGPoint(x: itemCenter.x + center.x - 149, y: itemCenter.y + center.y - 149)

        menu.updateHover(hover)
        #expect(menu.wrapThoseChilderen == tool)
        #expect(abs(menu.itemViews[index].transform.scaleFactor - 1.4) < 0.001)

        menu.updateHover(nil)
        #expect(menu.wrapThoseChilderen == nil)
        #expect(abs(menu.itemViews[index].transform.scaleFactor - 1) < 0.001)
    }

    @Test func hoverOutsideItemsClearsSelection() {
        let menu = makeMenu()
        menu.updateHover(menu.center)
        #expect(menu.wrapThoseChilderen == nil)
    }

    @Test func visibility() {
        let menu = makeMenu()
        #expect(menu.isMenuShowing == false)
        #expect(menu.alpha == 0)
        #expect(menu.isUserInteractionEnabled == false)

        menu.setMenuShowing(true, animated: false)
        #expect(menu.alpha == 1)
        #expect(menu.transform == .identity)
        #expect(menu.isUserInteractionEnabled)

        menu.setMenuShowing(false, animated: false)
        #expect(menu.alpha == 0)
        #expect(abs(menu.transform.a - 0.5) < 0.001)
    }

    @Test func tappingItemCallsHandler() async {
        let menu = makeMenu()
        await confirmation { selected in
            menu.toolSelectionHandler = { tool in
                #expect(tool == .lasso)
                selected()
            }
            menu.itemViews[1].sendActions(for: .primaryActionTriggered)
        }
    }
}

private extension CGAffineTransform {
    var scaleFactor: Double { sqrt(a * a + c * c) }
}
