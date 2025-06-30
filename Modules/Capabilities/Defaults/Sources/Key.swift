//  Created by Geoff Pado on 1/20/25.
//  Copyright © 2025 Cocoatype, LLC. All rights reserved.

import Foundation

public struct Key<ValueType: DefaultsRepresentable>: Sendable {
    let value: String
    init(value: String) {
        self.value = value
    }

    var valueDidChange: Notification.Name {
        Notification.Name("Defaults.valueDidChange.\(value)")
    }
}

public enum Keys {
    public static let numberOfSaves = Key<Int>(
        value: "Defaults.Keys.numberOfSaves2"
    )
    public static let autoRedactionsCategoryNames = Key<Bool>(
        value: "Defaults.Keys.autoRedactionsCategoryNames"
    )
    public static let autoRedactionsCategoryAddresses = Key<Bool>(
        value: "Defaults.Keys.autoRedactionsCategoryAddresses"
    )
    public static let autoRedactionsCategoryPhoneNumbers = Key<Bool>(
        value: "Defaults.Keys.autoRedactionsCategoryPhoneNumbers"
    )
    public static let autoRedactionsSet = Key<[String: Bool]>(
        value: "Defaults.Keys.autoRedactionsSet"
    )
    public static let recentBookmarks = Key<[Data]>(
        value: "Defaults.Keys.recentBookmarks"
    )
    public static let hideDocumentScanner = Key<Bool>(
        value: "Defaults.Keys.hideDocumentScanner"
    )
    public static let hideAutoRedactions = Key<Bool>(
        value: "Defaults.Keys.hideAutoRedactions"
    )

    // Debug Overlay
    public static let showDetectedTextOverlay = Key<Bool>(
        value: "Defaults.Keys.showDetectedTextOverlay"
    )
    public static let showDetectedCharactersOverlay = Key<Bool>(
        value: "Defaults.Keys.showDetectedCharactersOverlay"
    )
    public static let showRecognizedTextOverlay = Key<Bool>(
        value: "Defaults.Keys.showRecognizedTextOverlay"
    )
    public static let showCalculatedOverlay = Key<Bool>(
        value: "Defaults.Keys.showCalculatedOverlay"
    )
    public static let showCombinedOverlay = Key<Bool>(
        value: "Defaults.Keys.showCombinedOverlay"
    )
}
