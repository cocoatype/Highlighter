//  Created by Geoff Pado on 5/16/20.
//  Copyright © 2020 Cocoatype, LLC. All rights reserved.

import Editing
import Photos
import UIKit

protocol CollectionTableViewCell {
    static var identifier: String { get }
    var collection: Collection? { get set }
}
