//  Created by Geoff Pado on 5/15/19.
//  Copyright © 2019 Cocoatype, LLC. All rights reserved.

import Geometry
import Observations
import UIKit

extension Redaction {
    public init?(_ characterObservations: [CharacterObservation], color: UIColor) {
        guard characterObservations.count > 0 else { return nil }

        let parts = characterObservations.reduce(into: [UUID: [CharacterObservation]]()) { result, characterObservation in
            let textObservationUUID = characterObservation.textObservationUUID
            var siblingObservations = result[textObservationUUID] ?? []
            siblingObservations.append(characterObservation)
            result[textObservationUUID] = siblingObservations
        }.values.map { siblingObservations in
            MinimumAreaShapeFinder.minimumAreaShape(for: siblingObservations.map(\.bounds))
        }.map(RedactionPart.shape)

        self.init(color: color, parts: parts)
    }
}
