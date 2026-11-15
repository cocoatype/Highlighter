//  Created by Geoff Pado on 3/3/25.
//  Copyright © 2025 Cocoatype, LLC. All rights reserved.

import Testing
import UIKit

@testable import IntroView

@MainActor
struct IntroViewControllerTests {
    @Test
    func loadsIntroView() {
        let viewController = IntroViewController()
        viewController.loadViewIfNeeded()
        #expect(viewController.view is IntroView)
        #expect(viewController.navigationItem.rightBarButtonItem != nil)
    }
}
