//  Created by Geoff Pado on 7/31/24.
//  Copyright © 2024 Cocoatype, LLC. All rights reserved.

import UIKit

public enum PencilMenuInteractionPhase: Sendable {
    case began
    case changed
    case ended
    case cancelled

    @available(iOS 17.5, *)
    public init(_ pencilInteractionPhase: UIPencilInteraction.Phase) {
        self = switch pencilInteractionPhase {
        case .began: .began
        case .changed: .changed
        case .ended: .ended
        case .cancelled: .cancelled
        @unknown default: .cancelled
        }
    }
}
