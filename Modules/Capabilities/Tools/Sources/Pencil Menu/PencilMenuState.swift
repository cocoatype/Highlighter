//  Created by Geoff Pado on 7/31/24.
//  Copyright © 2024 Cocoatype, LLC. All rights reserved.

public indirect enum PencilMenuState: Sendable {
    case closed
    case squeezed(next: PencilMenuState)
    case open

    public var isOpen: Bool {
        switch self {
        case .squeezed, .open: true
        case .closed: false
        }
    }
}
