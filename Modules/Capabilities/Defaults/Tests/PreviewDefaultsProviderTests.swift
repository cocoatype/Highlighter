//  Created by Geoff Pado on 1/20/25.
//  Copyright © 2025 Cocoatype, LLC. All rights reserved.

import Testing

@testable import Defaults

struct PreviewDefaultsProviderTests {
    @Test func boolValueIsFalse() async {
        #expect(await PreviewDefaultsProvider().value(for: Key<Bool>(value: "key")) == false)
    }

    @Test func stringValueIsNil() async {
        #expect(await PreviewDefaultsProvider().value(for: Key<String>(value: "key")) == nil)
    }

    @Test func setStringValueIsNoOp() async {
        let provider = PreviewDefaultsProvider()
        let key = Key<String>(value: "key")
        await provider.set("value", for: key)
        #expect(await provider.value(for: key) == nil)
    }

    @Test func setBoolValueIsNoOp() async {
        let provider = PreviewDefaultsProvider()
        let key = Key<Bool>(value: "key")
        await provider.set(true, for: key)
        #expect(await provider.value(for: key) == false)
    }
}
