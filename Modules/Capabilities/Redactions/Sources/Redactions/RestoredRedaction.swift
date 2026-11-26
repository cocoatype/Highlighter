//  Created by Geoff Pado on 9/2/19.
//  Copyright © 2019 Cocoatype, LLC. All rights reserved.

#if canImport(UIKit)
import UIKit

extension Redaction: Codable {
    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let colorData = try container.decode(Data.self, forKey: .color)
        let pathsData = try container.decode([Data].self, forKey: .paths)

        let color = try NSKeyedUnarchiver.unarchivedObject(ofClass: UIColor.self, from: colorData) ?? .black
        let paths = try pathsData.compactMap { try NSKeyedUnarchiver.unarchivedObject(ofClass: UIBezierPath.self, from: $0) }
        let parts = RedactionSerializer.parts(from: paths)

        self.init(color: color, parts: parts)
    }

    public func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        let colorData = try NSKeyedArchiver.archivedData(withRootObject: color, requiringSecureCoding: true)
        let pathsData = parts.map(\.bezierPath).compactMap { try? NSKeyedArchiver.archivedData(withRootObject: $0, requiringSecureCoding: true) }

        try container.encode(colorData, forKey: .color)
        try container.encode(pathsData, forKey: .paths)
    }

    enum CodingKeys: CodingKey {
        case color, paths
    }
}
#endif
