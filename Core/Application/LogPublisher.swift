//  Created by Geoff Pado on 5/13/21.
//  Copyright © 2021 Cocoatype, LLC. All rights reserved.

import Combine
import os.log

struct LogPublisher<Upstream: Publisher>: Publisher {
    typealias Output = Upstream.Output
    typealias Failure = Upstream.Failure

    init(upstream: Upstream) {
        self.upstream = upstream
    }

    func receive<S>(subscriber: S) where S : Subscriber, Upstream.Failure == S.Failure, Upstream.Output == S.Input {
        upstream.subscribe(LogSubscriber(upstream: upstream, downstream: subscriber))
    }

    private let upstream: Upstream
}

private struct LogSubscriber<Upstream: Publisher, Downstream: Subscriber>: Subscriber where Upstream.Failure == Downstream.Failure, Upstream.Output == Downstream.Input {
    typealias Input = Upstream.Output
    typealias Failure = Upstream.Failure

    init(upstream: Upstream, downstream: Downstream) {
        self.upstream = upstream
        self.downstream = downstream
    }

    func receive(_ input: Upstream.Output) -> Subscribers.Demand {
        os_log("received input: %@", String(describing: input))
        return downstream.receive(input)
    }

    func receive(completion: Subscribers.Completion<Upstream.Failure>) {
        os_log("received completion: %@", String(describing: completion))
        return downstream.receive(completion: completion)
    }

    func receive(subscription: Subscription) {
        os_log("received subscription: %@", String(describing: subscription))
        return downstream.receive(subscription: subscription)
    }

    private let upstream: Upstream
    private let downstream: Downstream
    let combineIdentifier = CombineIdentifier()
}

extension Publisher {
    func log() -> LogPublisher<Self> {
        return LogPublisher(upstream: self)
    }
}
