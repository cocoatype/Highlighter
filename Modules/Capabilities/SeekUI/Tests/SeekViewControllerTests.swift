//  Created by Geoff Pado on 11/25/26.
//  Copyright © 2026 Cocoatype, LLC. All rights reserved.

import Testing
import UIKit

@testable import SeekUI

@MainActor
struct SeekViewControllerTests {
    @Test func tabletSeekViewControllerIsPresentedAsPopover() {
        let viewController = TabletSeekViewController()

        #expect(viewController.modalPresentationStyle == .popover)
        #expect(viewController.view is TabletSeekView)
    }

    @Test func tabletSeekViewControllerKeepsSearchBarAspectRatio() {
        let viewController = TabletSeekViewController()
        let size = viewController.preferredContentSize

        #expect(size.height > 0)
        #expect(abs(size.width / size.height - 320.0 / 56.0) < 0.001)
    }

    @Test func desktopSeekViewControllerIsPresentedOverCurrentContext() {
        let viewController = DesktopSeekViewController()

        #expect(viewController.modalPresentationStyle == .overCurrentContext)
        #expect(viewController.modalTransitionStyle == .crossDissolve)
        #expect(viewController.view is DesktopSeekContainerView)
    }
}
