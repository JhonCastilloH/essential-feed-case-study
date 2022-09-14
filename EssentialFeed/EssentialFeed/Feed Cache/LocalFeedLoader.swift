//
//  LocalFeedLoader.swift
//  EssentialFeed
//
//  Created by john Castillo on 7/09/22.
//  Copyright © 2022 Essential Developer. All rights reserved.
//

import Foundation

public final class FeedCachePolicy {
    private let currentDate: () -> Date
    private let calendar = Calendar(identifier: .gregorian)
    
    public init(currentDate: @escaping () -> Date) {
        self.currentDate = currentDate
    }
    
    private var maxCacheAgeInDays: Int {
        return 7
    }
    
    public func validate(_ timestamp: Date) -> Bool {
        guard let maxCacheAge = calendar.date(byAdding: .day, value: maxCacheAgeInDays, to: timestamp) else {
            return false
        }
        return currentDate() < maxCacheAge
    }
}

public final class LocalFeedLoader {
    private let store: FeedStore
    private let currentDate: () -> Date
    private let feedCachePolicy: FeedCachePolicy
    
    public init(store: FeedStore, currentDate: @escaping () -> Date) {
        self.store = store
        self.currentDate = currentDate
        self.feedCachePolicy = FeedCachePolicy(currentDate: currentDate)
    }
    
}
    
extension LocalFeedLoader {
    public typealias SaveResult = Error?
    public func save(_ feed: [FeedImage], completion: @escaping (SaveResult) -> Void) {
        store.deleteCacheFeed { [weak self] error in
            guard let self = self else { return }
            if let cacheDeletionError = error {
                completion(cacheDeletionError)
            } else {
                self.cache(feed, completion: completion)
            }
        }
    }
    
    private func cache(_ feed: [FeedImage], completion: @escaping (SaveResult) -> Void) {
        store.insert(feed.toLocal(), timestamp: currentDate(), completion: {
            [weak self] error in
            guard self != nil else { return }
            completion(error)
        })
    }
}
 
extension LocalFeedLoader: FeedLoader {
    public typealias RetriveResult = LoadFeedResult
    public func load(completion: @escaping (RetriveResult) -> Void) {
        store.retrive { [weak self] result in
            guard let self = self else { return }
            switch result {
            case let .failure(error):
                completion(.failure(error))
            case let .found(feed, timestamp) where self.feedCachePolicy.validate(timestamp):
                completion(.success(feed.toModels()))
            case .found, .empty:
                completion(.success([]))
            
            }
        }
    }
}
    
extension LocalFeedLoader {
    public func validateCache() {
        store.retrive { [weak self] result in
            guard let self = self else { return }
            switch result {
            case let .found(_, timestamp)  where !self.feedCachePolicy.validate(timestamp):
                self.store.deleteCacheFeed { _ in }
            case .failure:
                self.store.deleteCacheFeed { _ in }
            case .empty, .found: break
            }
        }
    }
}
    
private extension Array where Element == FeedImage {
    func toLocal() -> [LocalFeedImage] {
        return map {
            LocalFeedImage(id: $0.id, description: $0.description, location: $0.location, url: $0.url)}
    }
}

private extension Array where Element == LocalFeedImage {
    func toModels() -> [FeedImage] {
        return map {
            FeedImage(id: $0.id, description: $0.description, location: $0.location, url: $0.url)}
    }
}

