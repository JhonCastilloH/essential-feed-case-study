//
//  FeedStore.swift
//  EssentialFeed
//
//  Created by john Castillo on 7/09/22.
//  Copyright © 2022 Essential Developer. All rights reserved.
//

import Foundation

public protocol FeedStore {
    typealias DeletionCompletion = (Error?) -> Void
    typealias InsertionCompletion = (Error?) -> Void
    func deleteCacheFeed(completion: @escaping DeletionCompletion)
    func insert(_ feed:[LocalFeedImage], timestamp: Date, completion: @escaping InsertionCompletion)
}
