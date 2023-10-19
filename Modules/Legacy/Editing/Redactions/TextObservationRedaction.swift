//  Created by Geoff Pado on 7/29/19.
//  Copyright © 2019 Cocoatype, LLC. All rights reserved.

#if canImport(AppKit) && !targetEnvironment(macCatalyst)
import AppKit

extension Redaction {
    public init<ObservationType: TextObservation>(_ textObservation: ObservationType, color: NSColor) {
        let shape = textObservation.bounds
        self.init(color: color, parts: [.shape(shape)])
    }
}

#elseif canImport(UIKit)
import UIKit

extension Redaction {
    public init<ObservationType: TextObservation>(_ textObservation: ObservationType, color: UIColor) {
        let shape = textObservation.bounds
        self.init(color: color, parts: [.shape(shape)])
    }
}
#endif
