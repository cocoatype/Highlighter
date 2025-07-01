//  Created by Geoff Pado on 7/1/25.
//  Copyright © 2025 Cocoatype, LLC. All rights reserved.

import Testing

import TestHelpersInterface

extension Confirmation: TestHelpersInterface.Expectation {
    public func fulfill() { confirm() }
}
