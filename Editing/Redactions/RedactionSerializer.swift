//  Created by Geoff Pado on 10/16/19.
//  Copyright © 2019 Cocoatype, LLC. All rights reserved.

import Foundation

public class RedactionSerializer: NSObject {
    public static func dataRepresentation(of redaction: Redaction) -> Data {
        do {
            let restoredRedaction = RestoredRedaction(paths: redaction.paths, color: redaction.color)
            let redactionData = try PropertyListEncoder().encode(restoredRedaction)
            return redactionData
        } catch { return Data() }
    }

    public static func redaction(from dataRepresentation: Data) -> RestoredRedaction? {
        do {
            return try PropertyListDecoder().decode(RestoredRedaction.self, from: dataRepresentation)
        } catch { return nil }
    }

    public static func redaction(fromLegacyData dataRepresentation: [Data]) -> RestoredRedaction? {
        do {
            let paths = try dataRepresentation.compactMap { try NSKeyedUnarchiver.unarchivedObject(ofClass: UIBezierPath.self, from: $0) }
            return RestoredRedaction(paths: paths, color: .black)
        } catch { return nil }
    }
}
