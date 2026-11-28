//  Created by Geoff Pado on 6/17/24.
//  Copyright © 2024 Cocoatype, LLC. All rights reserved.

import Foundation
import Observations

struct ObservationCalculationPass {
    // a dictionary with a key of a recognized observation, and a value of an
    // array of matching detected observations
    var recognizedObservations = [CharacterObservation: [CharacterObservation]]()

    // any detected observations who have no matching recognized observations
    var orphanedObservations = [CharacterObservation]()
}
