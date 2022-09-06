//
//  CacheFeedUseCaseTests.swift
//  EssentialFeedTests
//
//  Created by john Castillo on 6/09/22.
//  Copyright © 2022 Essential Developer. All rights reserved.
//

import XCTest

class LocaleFeedLoader {
    init(store: FeedStore){}
}

class FeedStore {
    var deleteCachedFeedCallCount = 0
}

class CacheFeedUseCaseTests: XCTestCase {
    
    func test_init_doesNotDeleteCacheUponCreation() {
        
        let store = FeedStore()
        let _ = LocaleFeedLoader(store: store)
        
        XCTAssertEqual(store.deleteCachedFeedCallCount, 0)
    }
}
    
 
