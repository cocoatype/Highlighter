//  Created by Geoff Pado on 7/29/19.
//  Copyright © 2019 Cocoatype, LLC. All rights reserved.

#if canImport(AppKit) && !targetEnvironment(macCatalyst)
import AppKit

extension Redaction {
    public init<ObservationType: TextObservation>(_ textObservation: ObservationType, color: NSColor) {
        let rect = textObservation.bounds
        let path = NSBezierPath()
        let width = rect.height
        path.lineWidth = width
        path.move(to: CGPoint(x: rect.minX + (width * 0.8), y: rect.midY))
        path.line(to: CGPoint(x: rect.maxX - (width * 0.8), y: rect.midY))
        self.paths = [path]

        self.color = color
    }
}

#elseif canImport(UIKit)
import UIKit

extension Redaction {
    public init<ObservationType: TextObservation>(_ textObservation: ObservationType, color: UIColor) {
        let rect = textObservation.bounds
        let path = UIBezierPath()
        let width = rect.height
        path.lineWidth = width
        path.move(to: CGPoint(x: rect.minX + (width * 0.8), y: rect.midY))
        path.addLine(to: CGPoint(x: rect.maxX - (width * 0.8), y: rect.midY))
        self.paths = [path]

        self.color = color
    }
}
#endif
