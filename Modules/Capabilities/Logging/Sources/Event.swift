//  Created by Geoff Pado on 5/5/23.
//  Copyright © 2023 Cocoatype, LLC. All rights reserved.

public struct Event {
    let name: Name
    let info: [String: String]
    var value: String { String(name.value) }

    public init(name: Name, info: [String : String]) {
        self.name = name
        self.info = info
    }

    public struct Name: ExpressibleByStringLiteral {
        fileprivate let value: StaticString
        public init(_ value: StaticString) {
            self.value = value
        }

        public init(stringLiteral value: StaticString) {
            self.init(value)
        }
    }
}

extension String {
    init(_ staticString: StaticString) {
        let buffer = staticString.withUTF8Buffer { $0 }
        self.init(decoding: buffer, as: UTF8.self)
    }
}
