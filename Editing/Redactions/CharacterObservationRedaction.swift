//  Created by Geoff Pado on 5/15/19.
//  Copyright © 2019 Cocoatype, LLC. All rights reserved.

#if canImport(AppKit) && !targetEnvironment(macCatalyst)
import AppKit

extension Redaction {
    init?(_ characterObservations: [CharacterObservation], color: NSColor) {
        guard characterObservations.count > 0 else { return nil }

        self.paths = characterObservations.reduce(into: [UUID: [CharacterObservation]]()) { result, characterObservation in
            let textObservationUUID = characterObservation.textObservationUUID
            var siblingObservations = result[textObservationUUID] ?? []
            siblingObservations.append(characterObservation)
            result[textObservationUUID] = siblingObservations
        }.values.map { siblingObservations in
            siblingObservations.reduce(siblingObservations[0].bounds, { currentRect, characterObservation in
                currentRect.union(characterObservation.bounds)
            })
        }.map { shape -> NSBezierPath in
            return NSBezierPath(cgPath: shape.path)
        }

        self.color = color
    }
}

#elseif canImport(UIKit)
import UIKit

extension Redaction {
    init?(_ characterObservations: [CharacterObservation], color: UIColor) {
        guard characterObservations.count > 0 else { return nil }

        self.paths = characterObservations.reduce(into: [UUID: [CharacterObservation]]()) { result, characterObservation in
            let textObservationUUID = characterObservation.textObservationUUID
            var siblingObservations = result[textObservationUUID] ?? []
            siblingObservations.append(characterObservation)
            result[textObservationUUID] = siblingObservations
        }.values.map { siblingObservations in
            siblingObservations.reduce(siblingObservations[0].bounds, { currentRect, characterObservation in
                currentRect.union(characterObservation.bounds)
            })
        }.map { shape in
            return UIBezierPath(cgPath: shape.path)
        }

        self.color = color
    }
}
#endif
