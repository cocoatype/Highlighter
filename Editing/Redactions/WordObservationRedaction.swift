//  Created by Geoff Pado on 5/29/20.
//  Copyright © 2020 Cocoatype, LLC. All rights reserved.

import UIKit

#if canImport(UIKit)
extension Redaction {
    init(_ wordObservations: [WordObservation], color: UIColor) {
        self.paths = wordObservations.reduce(into: [UUID: [WordObservation]]()) { result, wordObservation in
            let textObservationUUID = wordObservation.textObservationUUID
            var siblingObservations = result[textObservationUUID] ?? []
            siblingObservations.append(wordObservation)
            result[textObservationUUID] = siblingObservations
        }.values.map { siblingObservations in
            siblingObservations.reduce(siblingObservations[0].bounds, { currentRect, wordObservation in
                currentRect.union(wordObservation.bounds)
            })
        }.map { rect in
            let path = UIBezierPath()
            let width = rect.height
            path.lineWidth = width
            path.move(to: CGPoint(x: rect.minX + (width * 0.8), y: rect.midY))
            path.addLine(to: CGPoint(x: rect.maxX - (width * 0.8), y: rect.midY))
            return path
        }
        self.color = color
    }
}
#endif
