//  Created by Geoff Pado on 4/11/21.
//  Copyright © 2021 Cocoatype, LLC. All rights reserved.

import XCTest

@testable import Editing

enum TestHelpers {
    static func runOnMacCatalyst() throws {
        #if targetEnvironment(macCatalyst)
        #else
        throw XCTSkip("This test is only run on Mac Catalyst")
        #endif
    }

    static func skipOnMacCatalyst() throws {
        #if targetEnvironment(macCatalyst)
        throw XCTSkip("This test is not run on Mac Catalyst")
        #endif
    }

    static func performInLightMode(_ actions: (() -> Void)) {
        UITraitCollection(userInterfaceStyle: .light).performAsCurrent(actions)
    }

    static func performInDarkMode(_ actions: (() -> Void)) {
        UITraitCollection(userInterfaceStyle: .dark).performAsCurrent(actions)
    }

    static let shape = Shape(
        bottomLeft: CGPoint(x: 0, y: 5),
        bottomRight: CGPoint(x: 5, y: 5),
        topLeft: CGPoint(x: 0, y: 0),
        topRight: CGPoint(x: 5, y: 0)
    )

    static let emptyShape = Shape(
        bottomLeft: CGPoint(x: 5, y: 5),
        bottomRight: CGPoint(x: 5, y: 5),
        topLeft: CGPoint(x: 5, y: 5),
        topRight: CGPoint(x: 5, y: 5)
    )
}
