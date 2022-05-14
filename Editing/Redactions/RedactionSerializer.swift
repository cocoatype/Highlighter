//  Created by Geoff Pado on 10/16/19.
//  Copyright © 2019 Cocoatype, LLC. All rights reserved.

import Foundation

public class RedactionSerializer: NSObject {
    public static func dataRepresentation(of redaction: Redaction) -> Data {
        do {
            let restoredRedaction = Redaction(color: redaction.color, paths: redaction.paths)
            let redactionData = try PropertyListEncoder().encode(restoredRedaction)
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
            return Redaction(color: .black, paths: paths)
        } catch { return nil }
    }
}
