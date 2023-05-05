//  Created by Geoff Pado on 7/1/22.
//  Copyright © 2022 Cocoatype, LLC. All rights reserved.

import UIKit

class RedactedWordObservationRotor: UIAccessibilityCustomRotor {
    init(accessibilityElements: [WordObservationAccessibilityElement]?) {
        super.init(name: Self.name) { predicate in
            guard let accessibilityElements = accessibilityElements,
                  let currentItem = Result(result: predicate.currentItem),
                  let currentItemIndex = accessibilityElements.firstIndex(of: currentItem.element)
            else { return nil }

            switch predicate.searchDirection {
            case .previous:
                return accessibilityElements[0..<currentItemIndex]
                    .reversed()
                    .first(where: \.isRedacted)
                    .map(Result.init(element:))
            case .next where currentItemIndex == accessibilityElements.endIndex - 1:
                return nil
            case .next:
                return accessibilityElements[(currentItemIndex + 1)..<accessibilityElements.endIndex]
                    .first(where: \.isRedacted)
                    .map(Result.init(element:))
            @unknown default:
                return nil
            }
        }
    }

    class Result: UIAccessibilityCustomRotorItemResult {
        let element: WordObservationAccessibilityElement
        init(element: WordObservationAccessibilityElement) {
            self.element = element
            super.init(targetElement: element, targetRange: nil)
        }

        convenience init?(result: UIAccessibilityCustomRotorItemResult) {
            guard let element = result.targetElement as? WordObservationAccessibilityElement
            else { return nil }

            self.init(element: element)
        }
    }

    private static let name = NSLocalizedString("RedactedWordObservationRotor.name", comment: "Name for the redacted words custom accessibility rotor")
}
