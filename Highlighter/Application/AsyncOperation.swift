//  Created by Geoff Pado on 8/17/19.
//  Copyright © 2019 Cocoatype, LLC. All rights reserved.

import Foundation

class AsyncOperation<ResultSuccess, ResultFailure: Error>: Operation {
    var result: Result<ResultSuccess, ResultFailure>?
    override var isAsynchronous: Bool { return true }

    private var _executing = false {
        willSet {
            willChangeValue(for: \.isExecuting)
        }

        didSet {
            didChangeValue(for: \.isExecuting)
        }
    }
    override var isExecuting: Bool { return _executing }

    private var _finished = false {
        willSet {
            willChangeValue(for: \.isFinished)
        }

        didSet {
            didChangeValue(for: \.isFinished)
        }
    }
    override var isFinished: Bool { return _finished }

    func succeed(_ success: ResultSuccess) {
        result = .success(success)
        _finished = true
        _executing = false
    }

    func fail(_ failure: ResultFailure) {
        result = .failure(failure)
        _finished = true
        _executing = false
    }
}

extension AsyncOperation where ResultSuccess == Void {
    func succeed() {
        self.succeed(())
    }
}
