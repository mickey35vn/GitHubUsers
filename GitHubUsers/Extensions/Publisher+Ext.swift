//
//  Publisher+Ext.swift
//  GitHubUsers
//
//  Created by Tram Nguyen on 29/08/2024.
//

import Foundation
import Combine

class ErrorTracker {
    private let subject = PassthroughSubject<Error, Never>()
    
    var errorPublisher: AnyPublisher<Error, Never> {
        subject.eraseToAnyPublisher()
    }
    
    /// Sends an error to the subscribers.
    /// - Parameter error: The error to be tracked and published.
    func track(_ error: Error) {
        subject.send(error)
    }
}

extension Publisher {
    
    /// Tracks errors emitted by the publisher and sends them to the specified error tracker.
    /// - Parameter tracker: An instance of an `ErrorTracker` that will handle the emitted errors.
    /// - Returns: A publisher that continues to emit values from the original publisher, but suppresses errors.
    func trackError<Tracker: ErrorTracker>(_ tracker: Tracker) -> AnyPublisher<Self.Output, Never> where Self.Failure == Error {
        self
            .catch { error -> Empty<Self.Output, Never> in
            tracker.track(error)
            return Empty()
        }
        .eraseToAnyPublisher()
    }
}

extension Publisher {
    
    /// Tracks the activity state of the publisher using the provided activity indicator.
    /// - Parameter activityIndicator: An instance of `ActivityIndicator` that will monitor the activity state.
    /// - Returns: A publisher that emits the same output and failure types as the original publisher.
    func trackActivity(_ activityIndicator: ActivityIndicator) -> AnyPublisher<Self.Output, Self.Failure> {
        activityIndicator.trackActivity(self)
    }
}

class ActivityIndicator {
    @Published private var count = 0
    private let lock = NSRecursiveLock()
    
    var isLoadingPublisher: AnyPublisher<Bool, Never> {
        $count
            .map({$0 > 0})
            .eraseToAnyPublisher()
        
    }
    
    /// Tracks the activity of a given publisher.
    /// - Parameter source: A publisher whose activity will be tracked.
    /// - Returns: A publisher that emits the same output and failure types as the original publisher.
    func trackActivity<T: Publisher>(_ source: T) -> AnyPublisher<T.Output, T.Failure> {
        return source
            .handleEvents(receiveCompletion: { _ in
                self.decrement()
            }, receiveCancel: {
                self.decrement()
            }, receiveRequest: { [weak self] _ in
                self?.increment()
            })
            .eraseToAnyPublisher()
    }
    
    /// Increments the count of active operations.
    private func increment() {
        lock.lock()
        defer { lock.unlock() }
        
        count += 1
    }
    
    /// Decrements the count of active operations.
    private func decrement() {
        lock.lock()
        defer { lock.unlock() }
        
        count -= 1
    }
}
