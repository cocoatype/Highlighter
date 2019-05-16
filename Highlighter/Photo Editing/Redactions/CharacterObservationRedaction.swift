//  Created by Geoff Pado on 5/15/19.
//  Copyright © 2019 Cocoatype, LLC. All rights reserved.

import UIKit

struct CharacterObservationRedaction: Redaction {
    init(_ characterObservations: [CharacterObservation]) {
        self.characterObservations = characterObservations

        self.paths = characterObservations.reduce(into: [UUID: [CharacterObservation]]()) { result, characterObservation in
            let textObservationUUID = characterObservation.textObservationUUID
            var siblingObservations = result[textObservationUUID] ?? []
            siblingObservations.append(characterObservation)
            result[textObservationUUID] = siblingObservations
            }.values.map { siblingObservations in
                siblingObservations.reduce(siblingObservations[0].bounds, { currentRect, characterObservation in
                    currentRect.union(characterObservation.bounds)
                })
            }.map { rect in
                let path = UIBezierPath()
                path.lineWidth = rect.height
                path.move(to: CGPoint(x: rect.minX, y: rect.midY))
                path.addLine(to: CGPoint(x: rect.maxX, y: rect.midY))
                return path
        }
    }

    let paths: [UIBezierPath]
    private let characterObservations: [CharacterObservation]
}
