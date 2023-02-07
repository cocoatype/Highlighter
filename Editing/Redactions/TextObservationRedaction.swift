//  Created by Geoff Pado on 7/29/19.
//  Copyright © 2019 Cocoatype, LLC. All rights reserved.

#if canImport(AppKit) && !targetEnvironment(macCatalyst)
import AppKit

extension Redaction {
    public init<ObservationType: TextObservation>(_ textObservation: ObservationType, color: NSColor) {
        let rect = textObservation.bounds
        let path = NSBezierPath(rect: rect.boundingBox)
        self.parts = [.path(path)]

        self.color = color
    }
}

#elseif canImport(UIKit)
import UIKit

extension Redaction {
    public init<ObservationType: TextObservation>(_ textObservation: ObservationType, color: UIColor) {
        let rect = textObservation.bounds
        let path = UIBezierPath(rect: rect.boundingBox)
        self.parts = [.path(path)]

        self.color = color
    }
}
#endif
