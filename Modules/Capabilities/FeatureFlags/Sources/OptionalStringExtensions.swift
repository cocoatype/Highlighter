//  Created by Geoff Pado on 2/25/25.
//  Copyright © 2025 Cocoatype, LLC. All rights reserved.

extension Optional<String> {
    public var isTruthy: Bool {
        guard let string = self else { return false }
        guard string.isEmpty == false else { return false }
        if let boolValue = Bool(string) {
            return boolValue
        } else if let intValue = Int(string), intValue == 0 {
            return false
        } else if string.caseInsensitiveCompare("NO") == .orderedSame {
            return false
        } else {
            return true
        }
    }
}
