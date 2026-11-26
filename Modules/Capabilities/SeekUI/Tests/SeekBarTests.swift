//  Created by Geoff Pado on 11/25/26.
//  Copyright © 2026 Cocoatype, LLC. All rights reserved.

import Testing
import UIKit

@testable import SeekUI

@MainActor
struct SeekBarTests {
    @Test func isHiddenWhenNotSeeking() {
        let seekBar = SeekBar()

        #expect(seekBar.isHidden)
        #expect(seekBar.isUserInteractionEnabled == false)
    }

    @Test func isShownWhenSeekingInCompactWidth() {
        let seekBar = SeekBar()

        seekBar.isSeeking = true

        #expect(seekBar.isHidden == false)
        #expect(seekBar.isUserInteractionEnabled)
    }

    @Test func isHiddenAgainWhenSeekingStops() {
        let seekBar = SeekBar()

        seekBar.isSeeking = true
        seekBar.isSeeking = false

        #expect(seekBar.isHidden)
        #expect(seekBar.isUserInteractionEnabled == false)
    }

    @Test func hasCancelButtonAndSearchField() throws {
        let seekBar = SeekBar()

        let cancelItem = try #require(seekBar.items?.first)
        #expect(cancelItem.action == #selector((any SeekActions).cancelSeeking(_:)))
        #expect(seekBar.searchTextField is SeekTextField)
    }
}
