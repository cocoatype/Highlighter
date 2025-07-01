//  Created by Geoff Pado on 6/27/25.
//  Copyright © 2025 Cocoatype, LLC. All rights reserved.

import Foundation

public protocol DefaultsRepresentable {}
extension Int: DefaultsRepresentable {}
extension Bool: DefaultsRepresentable {}
extension String: DefaultsRepresentable {}
extension Data: DefaultsRepresentable {}
extension Array: DefaultsRepresentable where Element: DefaultsRepresentable {}
extension Dictionary: DefaultsRepresentable where Key: DefaultsRepresentable, Value: DefaultsRepresentable {}
