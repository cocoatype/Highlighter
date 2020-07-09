//  Created by Geoff Pado on 10/16/19.
//  Copyright © 2019 Cocoatype, LLC. All rights reserved.

import Foundation


public class RedactionSerializer: NSObject {
    public static func dataRepresentation(of redaction: Redaction) -> [Data] {
        return redaction.paths.compactMap { try? NSKeyedArchiver.archivedData(withRootObject: $0, requiringSecureCoding: true) }
    }

    public static func redaction(from dataRepresentation: [Data]) -> RestoredRedaction? {
        do {
            let paths = try dataRepresentation.compactMap { try NSKeyedUnarchiver.unarchivedObject(ofClass: UIBezierPath.self, from: $0) }
            #warning("TODO (#111): Add restoration of colors")
            return RestoredRedaction(color: .black, paths: paths)
        } catch { return nil }
    }
}
