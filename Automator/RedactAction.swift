//  Created by Geoff Pado on 10/26/20.
//  Copyright © 2020 Cocoatype, LLC. All rights reserved.

import Automator
import os.log

class RedactAction: AMBundleAction {
    override func run(withInput input: Any?) throws -> Any {
        let input = input as Any
        guard let inputArray = input as? [Any] else { return input }

        let inputItems = inputArray.compactMap { inputItem -> Input? in
            switch inputItem {
            case let string as String:
                return Input.string(string)
            case let url as URL:
                return Input.url(url)
            case let data as Data:
                return Input.data(data)
            default: return nil
            }
        }

        var inputDump = String()
        dump(inputItems, to: &inputDump)
        os_log("foboar %{public}@", inputDump)

        return input
////        let inputDump = dump(input)
//        let array = input as? NSArray
//        let inputItem = array?.firstObject
//        return input
    }
}

enum Input {
    case string(String),
         url(URL),
         data(Data)
}
