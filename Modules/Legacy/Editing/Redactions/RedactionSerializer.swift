//  Created by Geoff Pado on 10/16/19.
//  Copyright © 2019 Cocoatype, LLC. All rights reserved.

import Foundation

public class RedactionSerializer: NSObject {
    public static func dataRepresentation(of redaction: Redaction) -> Data {
        do {
            let redactionData = try PropertyListEncoder().encode(redaction)
            return redactionData
        } catch { return Data() }
    }

    public static func redaction(from dataRepresentation: Data) -> Redaction? {
        do {
            return try PropertyListDecoder().decode(Redaction.self, from: dataRepresentation)
        } catch { return nil }
    }

    public static func redaction(fromLegacyData dataRepresentation: [Data]) -> Redaction? {
        do {
            let paths = try dataRepresentation.compactMap { try NSKeyedUnarchiver.unarchivedObject(ofClass: UIBezierPath.self, from: $0) }
            let parts = Self.parts(from: paths)
            return Redaction(color: .black, parts: parts)
        } catch { return nil }
    }

    public static func parts(from paths: [UIBezierPath]) -> [RedactionPart] {
        return paths.map { path -> RedactionPart in
            if let shape = path.shape {
                return .shape(shape)
            } else {
                return .path(path)
            }
        }
    }
}
